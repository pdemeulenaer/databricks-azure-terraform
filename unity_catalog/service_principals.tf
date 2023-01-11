// initialize provider at Azure account-level
provider "databricks" {
  alias      = "azure_account"
  host       = "https://accounts.azuredatabricks.net"
  account_id = var.databricks_account_id
  auth_type  = "azure-cli"
}

resource "databricks_service_principal" "sp" {
  provider       = databricks.azure_account
  application_id = var.application_id 
  display_name = "Data Engineers"
  workspace_access = true # meaningful or not?
}

resource "databricks_permission_assignment" "add_admin_spn" {
  principal_id = databricks_service_principal.sp.id
  permissions  = ["ADMIN"]
}
