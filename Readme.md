# AKS IaC with Terraform

### TODO:
1. Main Readme
2. Modules Readmes
3. Spot instances for node pools
4. Log Analytics create module
5. ACR create module
6. AAD create group


```bash
terraform init
terraform plan -o planfile
terraform apply -f planfile
```

## AKS cluster described as a set of variables
Describe your desired cluster as a set of variables.

## CRUD nodepools

You can add, delete, update nodepools in your code

make your changes under `additional_node_pools`:

```bash
...
      nodepool2 = {
        name                           = "nodepool2"
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
...
```

## Log Analytivs integration
Integrate your cluster with Azure Monitor. Under `addons` section set `oms_agent.enabled` to `true` and specify `log_analytics_workspace_id`

```bash
...
    addons = {
      oms_agent   = {
        enabled = false # if true, put the right analytics_workspace_id. see example below. if false, leave analytics_workspace_id as described below
        log_analytics_workspace_id = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-name/providers/Microsoft.OperationalInsights/workspaces/workspace-name"
      }
      kubernetes_dashboard = false
      azure_policy         = false
    }
...
```

# ACR integration
Integrate your cluster with Azure Container Registry(ACR)

```bash
...
  container_registry = {
    enabled = false # if true, put the right container registry id to create 'pull' role assignement. if false, leave id as described below
    id = "aksacr"
  }
...
```

## Get credentials

### Admin

```bash
az aks get-credentials --resource-group myResourceGroup --name myManagedCluster --admin -f ./kubeconfig.clustername
export KUBECONFIG=./kubeconfig.clustername
```

### Azure AD integration

This terraform code integrates AKS with AAD, but if you do not specify ids you won't be able to authenticate and need admin credentials.

Note, id of the group(s) must be specified in the next section of the `variavles.tf` file

```bash
...
    role_based_access_control = {
      enabled = true
      azure_active_directory = {
        managed = true
        admin_group_object_ids = ["12345678-1234-1234-1234-123456789012"]
      }
    }
...
```

```bash
az aks get-credentials --resource-group myResourceGroup --name myManagedCluster -f ./kubeconfig.clustername
export KUBECONFIG=./kubeconfig.clustername
```
