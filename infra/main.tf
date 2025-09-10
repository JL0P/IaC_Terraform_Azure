# RG
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

# Storage per AML
resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"


  blob_properties {
    versioning_enabled = true
    change_feed_enabled = true

    delete_retention_policy {
        days= 20
        }
    container_delete_retention_policy {
        days= 20
        }
   }  

}

# Key Vault
resource "azurerm_key_vault" "kv" {
  name                       = var.key_vault_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
}

data "azurerm_client_config" "current" {}

# Application Insights
resource "azurerm_application_insights" "appi" {
  name                = var.appinsights_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

# ACR (utile per immagini custom)
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true
}

# Azure ML Workspace
resource "azurerm_machine_learning_workspace" "aml" {
  name                    = var.workspace_name
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name

  application_insights_id = azurerm_application_insights.appi.id
  key_vault_id            = azurerm_key_vault.kv.id
  storage_account_id      = azurerm_storage_account.sa.id
  container_registry_id   = azurerm_container_registry.acr.id

  identity {
    type = "SystemAssigned"
  }

  public_network_access_enabled = true
}

# Compute cluster (CPU)
resource "azurerm_machine_learning_compute_cluster" "cpu" {
  name                            = var.compute_name
  machine_learning_workspace_id   = azurerm_machine_learning_workspace.aml.id
  vm_size                         = var.vm_size

  scale_settings {
    min_node_count                       = var.min_nodes
    max_node_count                       = var.max_nodes
    scale_down_nodes_after_idle_duration = "PT2M"
  }
}
