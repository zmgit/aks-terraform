module "resource_group" {
  source   = "./modules/resource_group"
  name     = var.resource_group.name
  location = var.resource_group.location
  tags     = var.tags
}


module "network" {
  source                  = "./modules/network"
  vnet_name               = var.network.vnet.name
  location                = module.resource_group.location
  resource_group_name     = module.resource_group.name
  vnet_address_space      = [var.network.vnet.address_space]
  subnet_name             = var.network.subnet.name
  subnet_address_prefixes = [var.network.subnet.address_prefixes]
  tags                    = var.tags
  depends_on              = [module.resource_group]
}


module "aks" {
  source              = "./modules/aks"
  name                = var.aks.name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  dns_prefix          = var.aks.name
  kubernetes_version  = var.aks.kubernetes_version
  private_cluster     = var.aks.private_cluster
  sla_sku             = var.aks.sla_sku
  api_auth_ips        = var.aks.api_auth_ips
  vnet_subnet_id = module.network.subnet_id

  role_based_access_control = {
    enabled = var.aks.role_based_access_control.enabled
    azure_active_directory = {
      managed = var.aks.role_based_access_control.azure_active_directory.managed
      admin_group_object_ids = var.aks.role_based_access_control.azure_active_directory.managed != false ? var.aks.role_based_access_control.azure_active_directory.admin_group_object_ids : null
    }
  }

  default_node_pool = {
    name                           = var.aks.system_pool.name
    node_count                     = var.aks.system_pool.node_count
    vm_size                        = var.aks.system_pool.vm_size
    os_disk_size_gb                = var.aks.system_pool.os_disk_size_gb
    max_pods                       = var.aks.system_pool.max_pods
    enable_node_public_ip          = var.aks.system_pool.enable_node_public_ip
    zones                          = var.aks.system_pool.zones
    taints                         = var.aks.system_pool.taints
    cluster_auto_scaling           = var.aks.system_pool.cluster_auto_scaling
    cluster_auto_scaling_min_count = var.aks.system_pool.cluster_auto_scaling_min_count
    cluster_auto_scaling_max_count = var.aks.system_pool.cluster_auto_scaling_max_count
    labels                         = var.aks.system_pool.labels
  }

  addons = {
    oms_agent            = var.aks.addons.oms_agent.enabled
    kubernetes_dashboard = var.aks.addons.kubernetes_dashboard
    azure_policy         = var.aks.addons.azure_policy
  }

  log_analytics_workspace_id = var.aks.addons.oms_agent.log_analytics_workspace_id
  
  container_registry = {
    enabled = var.aks.container_registry.enabled
    id      = var.aks.container_registry.id
  }

  tags = var.tags
  depends_on = [module.network]
}


module "aks_nodepools" {
  source = "./modules/aks_nodepools"

  for_each = var.aks.additional_node_pools

  kubernetes_cluster_id = module.aks.cluster_id
  orchestrator_version  = module.aks.kubernetes_version
  vnet_subnet_id        = module.network.subnet_id

  additional_node_pools = {
    "${each.key}" = {
      name                           = each.value.name
      node_count                     = each.value.node_count
      node_os                        = each.value.node_os
      vm_size                        = each.value.vm_size
      os_disk_size_gb                = each.value.os_disk_size_gb
      max_pods                       = each.value.max_pods
      enable_node_public_ip          = each.value.enable_node_public_ip
      zones                          = each.value.zones
      taints                         = each.value.taints
      cluster_auto_scaling           = each.value.cluster_auto_scaling
      cluster_auto_scaling_min_count = each.value.cluster_auto_scaling_min_count
      cluster_auto_scaling_max_count = each.value.cluster_auto_scaling_max_count
      labels                         = each.value.labels
    }
  }

  tags       = var.tags
  depends_on = [module.aks]
}
