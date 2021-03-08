
terraform {
  required_version = ">= 0.14"

  required_providers {
    azurerm    = ">=2.47.0"
    azuread    = ">=1.3.0"
    kubernetes = ">= 1.11.0"
    helm       = ">= 1.1.2"
  }
}