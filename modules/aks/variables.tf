variable "container_registry" {
  description = "ACR id"
  type        = map
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace id"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "dns_prefix" {
  description = "dns_prefix"
  type        = string
}
variable "resource_group_name" {
  description = "Name of the AKS cluster resource group"
  type        = string
}

variable "location" {
  description = "Azure region of the AKS cluster"
  type        = string
}

variable "vnet_subnet_id" {
  description = "Resource id of the Virtual Network subnet"
  type        = string
}

variable "role_based_access_control" {
  description = "role-based access control"
#   type        = map
}

variable "api_auth_ips" {
  description = "Whitelist of IP addresses allowed to access the AKS API"
  type        = list(string)
}

variable "private_cluster" {
  description = "Deploy an AKS cluster without a public accessible API endpoint."
  type        = bool
}

variable "sla_sku" {
  description = "Define the SLA"
  type        = string
}

variable "default_node_pool" {
  description = "The default node pool object"
  type = object({
    name                           = string
    node_count                     = number
    vm_size                        = string
    max_pods                       = number
    os_disk_size_gb                = number
    zones                          = list(string)
    labels                         = map(string)
    taints                         = list(string)
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
    enable_node_public_ip          = bool
  })
}

variable "tags" {
  description = "Tags"
  type        = map(string)
}

variable "addons" {
  description = "Addons to be activated."
}