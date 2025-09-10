output "workspace_id"   { value = azurerm_machine_learning_workspace.aml.id }
output "workspace_name" { value = azurerm_machine_learning_workspace.aml.name }
output "resource_group" { value = azurerm_resource_group.rg.name }
output "compute_name"   { value = azurerm_machine_learning_compute_cluster.cpu.name }
output "acr_login"      { value = azurerm_container_registry.acr.login_server }