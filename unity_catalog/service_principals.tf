// initialize provider at Azure account-level
provider "databricks" {
  alias      = "azure_account"
  host       = "https://accounts.azuredatabricks.net"
  account_id = var.databricks_account_id
  auth_type  = "azure-cli"
}

# resource "databricks_service_principal" "sp" {
#   provider       = databricks.azure_account
#   application_id = "00000000-0000-0000-0000-000000000000"
# }

resource "databricks_service_principal" "sp" {
  provider       = databricks.azure_account
  application_id = var.application_id 
  display_name = "Data Engineers"
}

resource "databricks_mws_permission_assignment" "add_user_spn" {
  workspace_id = local.databricks_workspace_id #databricks_mws_workspaces.this.workspace_id
  principal_id = databricks_service_principal.sp.id
  permissions  = ["USER"]
}