terraform {
    backend "remote" {
    	organization = "example-org-d50e3c" # org name in Terraform Cloud
    	workspaces {
    		name = "databricks-azure-ws-configuration" # name of the workspace containing the state file
    	}
    }      
    required_providers {
        databricks = {
            source = "databricks/databricks"
            version = "1.8.0"
        }
    }
}

# SEE https://registry.terraform.io/providers/databricks/databricks/latest/docs#special-configurations-for-azure
provider "databricks" {
    # host = azurerm_databricks_workspace.this.workspace_url # or data. ...
    host = data.azurerm_databricks_workspace.this.workspace_url # taken from variables.tf
}

# where the "azurerm_databricks_workspace" could be like this (taken from UC init file):
# data "azurerm_databricks_workspace" "this" {
#   name                = local.databricks_workspace_name
#   resource_group_name = local.resource_group
# }

# OR we can simply describe the created WS like
# resource "azurerm_databricks_workspace" "this" {
#   location            = "centralus"
#   name                = "my-workspace-name"
#   resource_group_name = var.resource_group
#   sku                 = "premium"
# }

data "databricks_current_user" "me" {}
data "databricks_spark_version" "latest" {}
data "databricks_node_type" "smallest" {
#   local_disk = true # FAILING ! USE DIFFERENT NODE TYPE
    category = "General Purpose"
}