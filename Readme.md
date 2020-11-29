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

az aks get-credentials -g <name> -n <name> -f ./kubeconfig.clustername
export KUBECONFIG=./kubeconfig.clustername