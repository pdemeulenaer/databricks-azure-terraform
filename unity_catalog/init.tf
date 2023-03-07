terraform {
	backend "remote" {
		organization = "example-org-d50e3c" # org name in Terraform Cloud
		workspaces {
			name = "databricks-azure-uc" # name of the workspace containing the state file
		}
	}   
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.35.0"
    }
    databricks = {
      source = "databricks/databricks"
      version = "1.11.1"
    }
  }
}

provider "azurerm" {
  subscription_id = local.subscription_id
  features {}
}

provider "databricks" {
  host = local.databricks_workspace_host
}

# SEE ALSO IN https://registry.terraform.io/providers/databricks/databricks/latest/docs#special-configurations-for-azure

# // Initialize provider in "MWS" mode to provision the new workspace.
# // alias = "mws" instructs Databricks to connect to https://accounts.cloud.databricks.com, to create
# // a Databricks workspace that uses the E2 version of the Databricks on AWS platform.
# // See https://registry.terraform.io/providers/databricks/databricks/latest/docs#authentication
# provider "databricks" {
#   alias    = "mws"
#   host     = "https://accounts.cloud.databricks.com"
#   username = var.databricks_account_username
#   password = var.databricks_account_password
# }