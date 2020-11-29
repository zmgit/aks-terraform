variable "kubernetes_cluster_id" {
  description = "AKS cluster id"
  type        = string
}

variable "orchestrator_version" {
  description = "AKS K8s version"
  type        = string
}

variable "vnet_subnet_id" {
  description = "Vnet subnet id"
  type        = string
}

variable "tags" {
  description = "Resource Group Tags"
  type        = map(string)
}

variable "additional_node_pools" {
  description = "Additional node pools"
  type = map(object({
    name                           = string
    node_count                     = number
    vm_size                        = string
    zones                          = list(string)
    max_pods                       = number
    labels                         = map(string)
    taints                         = list(string)
    node_os                        = string
    os_disk_size_gb                = number
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
    enable_node_public_ip          = bool
  }))
}
