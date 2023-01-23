terraform {
  backend "remote" {
    organization = "example-org-d50e3c" # org name in Terraform Cloud
    workspaces {
      name = "databricks-azure-ws-configuration" # name of the workspace containing the state file
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.35.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.9.0"
    }
  }
}

provider "azurerm" {
  subscription_id = local.subscription_id
  features {}
}

# Default Databricks provider
provider "databricks" {
}

# SEE https://registry.terraform.io/providers/databricks/databricks/latest/docs#special-configurations-for-azure
provider "databricks" {
  alias = "dev"
  # host = azurerm_databricks_workspace.this.workspace_url # or data. ...
  host = data.azurerm_databricks_workspace.this.workspace_url # taken from variables.tf
}

provider "databricks" {
  alias = "staging"
  # host = azurerm_databricks_workspace.this.workspace_url # or data. ...
  # host = data.azurerm_databricks_workspace.this.workspace_url # taken from variables.tf
}

provider "databricks" {
  alias = "prod"
  # host = azurerm_databricks_workspace.this.workspace_url # or data. ...
  # host = data.azurerm_databricks_workspace.this.workspace_url # taken from variables.tf
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

module "wsconf" {
  source         = "./modules/ws-configuration"
  github_token   = var.github_token
  git_repo       = var.git_repo  
  providers = {
    databricks.dev     = databricks.dev      
  }  
}