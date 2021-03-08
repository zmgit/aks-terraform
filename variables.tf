variable "tags" {
  description = "Azure tags"
  type        = map(string)
  default = {
    source   = "terraform"
    app-name = "aks-demo"
    env      = "production"
  }
}


variable "resource_group" {
  description = "Resource Group Attributes"
  type        = map(string)
  default = {
    name     = "aks-rg"
    location = "westeurope"
  }
}


variable "network" {
  description = "Vnet Attributes"
  type        = map
  default = {
    vnet = {
      name          = "aks-vnet"
      address_space = "10.0.0.0/8"
    }
    subnet = {
      name             = "aks-subnet"
      address_prefixes = "10.254.0.0/16"
    }
  }
}


variable "aks" {
  description = "AKS Attributes"
  default = {
    name               = "aks"
    kubernetes_version = "1.18.10"
    sla_sku            = "Free"
    private_cluster    = false
    api_auth_ips       = [] # leave an empty array(e.g. []) to disable or specify CIDRs (e.g. ["192.168.0.0/24", "1.1.1.1/32"]) https://docs.microsoft.com/en-us/azure/aks/api-server-authorized-ip-ranges


    role_based_access_control = {
      enabled = true
      azure_active_directory = {
        managed = true
        # admin_group_object_ids = ["12345678-1234-1234-1234-123456789012"]
        admin_group_object_ids = []
      }
    }

  container_registry = {
    enabled = false # if true, put the right container registry id to create 'pull' role assignement. if false, leave id as described below
    id = "aksacr"
  }

    addons = {
      oms_agent   = {
        enabled = false # if true, put the right analytics_workspace_id. see example below. if false, leave analytics_workspace_id as described below
        log_analytics_workspace_id = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-name/providers/Microsoft.OperationalInsights/workspaces/workspace-name"
      }
      kubernetes_dashboard = false
      azure_policy         = false
    }

    system_pool = {
      name                           = "systempool"
      node_count                     = 3
      vm_size                        = "Standard_D2s_v3"
      os_disk_size_gb                = 128
      max_pods                       = 250
      enable_node_public_ip          = false
      zones                          = ["1", "2", "3"]
      taints                         = null
      cluster_auto_scaling           = false
      cluster_auto_scaling_min_count = null
      cluster_auto_scaling_max_count = null
      labels = {
        "pool_name" = "system_pool"
        "label_1"   = "value_1"
      }
    }

    additional_node_pools = {

      lnp1 = {
        name                           = "lnp1"
        node_count                     = 1
        node_os                        = "Linux"
        vm_size                        = "Standard_D4_v3"
        os_disk_size_gb                = 128
        max_pods                       = 250
        enable_node_public_ip          = false
        zones                          = ["1", "2", "3"]
        taints                         = null
        cluster_auto_scaling           = false
        cluster_auto_scaling_min_count = null
        cluster_auto_scaling_max_count = null
        labels = {
          "pool_name" = "node_pool_1"
          "label_1"   = "value_1"
        }
      }

      lnp2 = {
        name                           = "lnp2"
        node_count                     = 0
        node_os                        = "Linux"
        vm_size                        = "Standard_D4_v3"
        os_disk_size_gb                = 128
        max_pods                       = 250
        enable_node_public_ip          = false
        zones                          = ["1", "2", "3"]
        taints                         = null
        cluster_auto_scaling           = true
        cluster_auto_scaling_min_count = 0
        cluster_auto_scaling_max_count = 5
        labels = {
          "pool_name" = "node_pool_2"
          "label_1"   = "value_1"
        }
      }

      wnp3 = {
        name                           = "wnp3" # A Windows Node Pool cannot have a name longer than 6 characters.
        node_count                     = 1
        node_os                        = "Windows"
        vm_size                        = "Standard_D4_v3"
        os_disk_size_gb                = 128
        max_pods                       = 250
        enable_node_public_ip          = false
        zones                          = ["1", "2", "3"]
        taints                         = null
        cluster_auto_scaling           = false
        cluster_auto_scaling_min_count = null
        cluster_auto_scaling_max_count = null
        labels = {
          "pool_name" = "node_pool_2"
          "label_1"   = "value_1"
        }
      }

      wnp4 = {
        name                           = "wnp4" # A Windows Node Pool cannot have a name longer than 6 characters.
        node_count                     = 0
        node_os                        = "Windows"
        vm_size                        = "Standard_D4_v3"
        os_disk_size_gb                = 128
        max_pods                       = 250
        enable_node_public_ip          = false
        zones                          = ["1", "2", "3"]
        taints                         = null
        cluster_auto_scaling           = true
        cluster_auto_scaling_min_count = 0
        cluster_auto_scaling_max_count = 5
        labels = {
          "pool_name" = "node_pool_2"
          "label_1"   = "value_1"
        }
      }

    }
  }
}