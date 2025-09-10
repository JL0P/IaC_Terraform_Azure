variable "location" { type = string }
variable "resource_group" { type = string }
variable "workspace_name" { type = string }
variable "storage_account" { type = string }
variable "key_vault_name" { type = string }
variable "acr_name" { type = string }
variable "appinsights_name" { type = string }
variable "cl_priority" {
  type    = string
  default = "Dedicated"
}
variable "compute_name" {
  type    = string
  default = "cpu-cluster_j1"
}
variable "vm_size" {
  type    = string
  default = "Standard_DS3_v2"
}
variable "max_nodes" {
  type    = number
  default = 2
}
variable "min_nodes" {
  type    = number
  default = 0
}