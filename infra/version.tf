terraform {
  required_version = ">= 1.7.5"

  backend "azurerm" {}   # il dettaglio (RG/SA/container/key) lo passi in init dal workflow

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110"
    }
  }
}

provider "azurerm" {
  features {}
}