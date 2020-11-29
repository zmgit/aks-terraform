resource "azurerm_kubernetes_cluster_node_pool" "aks" {

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

  for_each = var.additional_node_pools

  kubernetes_cluster_id = var.kubernetes_cluster_id
  vnet_subnet_id        = var.vnet_subnet_id
  orchestrator_version  = var.orchestrator_version

  name                  = each.value.node_os == "Windows" ? substr(each.key, 0, 6) : substr(each.key, 0, 12)
  node_count            = each.value.node_count
  vm_size               = each.value.vm_size
  availability_zones    = each.value.zones
  max_pods              = each.value.max_pods
  os_disk_size_gb       = each.value.os_disk_size_gb
  os_type               = each.value.node_os
  node_labels           = each.value.labels
  node_taints           = each.value.taints
  enable_auto_scaling   = each.value.cluster_auto_scaling
  min_count             = each.value.cluster_auto_scaling_min_count
  max_count             = each.value.cluster_auto_scaling_max_count
  enable_node_public_ip = each.value.enable_node_public_ip
}
