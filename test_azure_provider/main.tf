terraform {
 
    required_providers {
        # azurerm = "2.33" #"~> 2.33"
		azurerm = {
			source = "hashicorp/azurerm"
			version = "2.33"
		}		
        external = {
            source = "hashicorp/external"
            version = "2.2.2"
        }        
        # random  = "~> 2.2"
    }
	
}

provider "azurerm" {
    features {}
}

# resource "random_string" "naming" {
#   special = false
#   upper   = false
#   length  = 6
# }

data "azurerm_client_config" "current" {
}

data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}

locals {
  # prefix = "databricks-tf-${random_string.naming.result}"
  prefix = "testing"
  tags = {
    # Environment = "Demo"
    Owner       = lookup(data.external.me.result, "name")
    Source      = "terraform"
  }
}

# 1. DEV WORKSPACE CREATION
# =========================

resource "azurerm_resource_group" "test" {
  name     = "${local.prefix}-rg"
  location = "westeurope"
  tags = merge(local.tags, {
    environment = "none"
  })
}