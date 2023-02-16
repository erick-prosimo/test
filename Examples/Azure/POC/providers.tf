terraform {
  required_version = ">=0.13"
  required_providers {
    prosimo = {
      source  = "prosimo.io/prosimo/prosimo"
      version = "1.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.6.0"
    }
  }
}