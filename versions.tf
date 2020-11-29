

terraform {
  required_version = ">= 0.13"

  required_providers {
    azurerm    = ">=2.37.0"
    azuread    = ">=1.1.0"
    kubernetes = "= 1.9.0"
    helm       = "= 0.10.2"
  }
}