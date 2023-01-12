terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      version = "1.8.0"
    }
  }
}

# SEE https://registry.terraform.io/providers/databricks/databricks/latest/docs#special-configurations-for-azure
provider "databricks" {
  host = azurerm_databricks_workspace.this.workspace_url # or data. ...
}