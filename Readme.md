# TODO:
1. Main Readme
2. Modules Readmes
3. Spot instances for node pools
4. Log Analytics create module
5. ACR create module
6. AAD create group

terraform init
terraform plan -o planfile
terraform apply -f planfile


# Azure AD integration

# Log Analytivs integration

# ACR integration


# Get credentials

## Admin
```bash
az aks get-credentials --resource-group myResourceGroup --name myManagedCluster --admin -f ./kubeconfig.clustername
export KUBECONFIG=./kubeconfig.clustername
```

## User (AAD) integration
This terraform code integrates AKS with AAD, but if you do not specify ids you won't be able to authenticate and need admin credentials.

### Note, id of gropups must be specify in

```bash
    role_based_access_control = {
      enabled = true
      azure_active_directory = {
        managed = true
        admin_group_object_ids = ["12345678-1234-1234-1234-123456789012"]
      }
    }
```

```bash
az aks get-credentials --resource-group myResourceGroup --name myManagedCluster -f ./kubeconfig.clustername
export KUBECONFIG=./kubeconfig.clustername
```
