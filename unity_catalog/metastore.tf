resource "databricks_metastore" "this" {
  name = "primary"
  storage_root = format("abfss://%s@%s.dfs.core.windows.net/",
    azurerm_storage_container.unity_catalog.name,
  azurerm_storage_account.unity_catalog.name)
  force_destroy = true
}

resource "databricks_metastore_data_access" "first" {
  metastore_id = databricks_metastore.this.id
  name         = "the-keys"
  azure_managed_identity {
    access_connector_id = azurerm_databricks_access_connector.unity.id
  }

  is_default = true
}

# Enabling the UC on the (one) workspace specified
# resource "databricks_metastore_assignment" "this" {
#   workspace_id         = local.databricks_workspace_id
#   metastore_id         = databricks_metastore.this.id
#   default_catalog_name = "hive_metastore"
# }

# Enabling the UC on ALL workspaces specified
resource "databricks_metastore_assignment" "default_metastore" {
  for_each             = toset(var.databricks_workspace_ids)
  workspace_id         = each.key
  metastore_id         = databricks_metastore.this.id
  default_catalog_name = "hive_metastore"
}