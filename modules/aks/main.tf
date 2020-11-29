resource "azurerm_kubernetes_cluster" "aks" {

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }

  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  dns_prefix                      = var.dns_prefix
  kubernetes_version              = var.kubernetes_version
  node_resource_group             = "MC_AKS_${var.resource_group_name}"
  private_cluster_enabled         = var.private_cluster
  sku_tier                        = var.sla_sku
  api_server_authorized_ip_ranges = var.api_auth_ips
  tags                            = var.tags

  default_node_pool {
    name                  = substr(var.default_node_pool.name, 0, 12)
    orchestrator_version  = var.kubernetes_version
    node_count            = var.default_node_pool.node_count
    vm_size               = var.default_node_pool.vm_size
    type                  = "VirtualMachineScaleSets"
    availability_zones    = var.default_node_pool.zones
    max_pods              = var.default_node_pool.max_pods
    os_disk_size_gb       = var.default_node_pool.os_disk_size_gb
    vnet_subnet_id        = var.vnet_subnet_id
    node_labels           = var.default_node_pool.labels
    node_taints           = var.default_node_pool.taints
    enable_auto_scaling   = var.default_node_pool.cluster_auto_scaling
    min_count             = var.default_node_pool.cluster_auto_scaling_min_count
    max_count             = var.default_node_pool.cluster_auto_scaling_max_count
    enable_node_public_ip = var.default_node_pool.enable_node_public_ip
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = var.role_based_access_control.enabled

    azure_active_directory {
      managed = var.role_based_access_control.azure_active_directory.managed
      admin_group_object_ids = var.role_based_access_control.azure_active_directory.managed != false ? var.role_based_access_control.azure_active_directory.admin_group_object_ids : null
    }
  }

  addon_profile {
    oms_agent {
      enabled                    = var.addons.oms_agent
      log_analytics_workspace_id = var.addons.oms_agent != false ? var.log_analytics_workspace_id : null
    }

    kube_dashboard {
      enabled = var.addons.kubernetes_dashboard
    }
    azure_policy {
      enabled = var.addons.azure_policy
    }
  }

  network_profile {
    load_balancer_sku  = "standard"
    outbound_type      = "loadBalancer"
    network_plugin     = "azure"
    network_policy     = "calico"
    dns_service_ip     = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "10.0.0.0/16"
  }
}

resource "azurerm_role_assignment" "aks_subnet" {
  scope                = var.vnet_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

resource "azurerm_role_assignment" "aks_monitoring_metrics" {
  # creates role assignment if oms_agent enabled
  count = var.addons.oms_agent ? 1 : 0
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_kubernetes_cluster.aks.addon_profile[0].oms_agent[0].oms_agent_identity[0].object_id
}

resource "azurerm_role_assignment" "aks_acr" {
  # creates role assignment if container registry defined
  count = var.container_registry.enabled ? 1 : 0
  scope                = var.container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}