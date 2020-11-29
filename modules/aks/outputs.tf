output "cluster_id" {
  value = "${azurerm_kubernetes_cluster.aks.id}"
}

output "kubernetes_version" {
  value = "${azurerm_kubernetes_cluster.aks.kubernetes_version}"
}