variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "tags" {
  description = "Resource Group Tags"
  type        = map(string)
}

variable "vnet_name" {
  description = "Vnet Name"
  type        = string
}

variable "location" {
  description = "Resource Group Location"
  type        = string
}

variable "vnet_address_space" {
  description = "Vnet address space"
  type        = list
}

variable "subnet_name" {
  description = "Subnet Name"
  type        = string
}

variable "subnet_address_prefixes" {
  description = "Subnet address prefixes"
  type        = list
}



