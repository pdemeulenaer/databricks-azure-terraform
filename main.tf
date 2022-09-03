terraform {
  required_providers {
    azurerm = "~> 2.33"
    random  = "~> 2.2"
  }
}

provider "azurerm" {
  features {}
}

variable "region" {
  type    = string
  default = "westeurope"
}

resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

data "azurerm_client_config" "current" {
}

data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}

locals {
  # prefix = "databricksdemo${random_string.naming.result}"
  prefix = "databricks-tf-${random_string.naming.result}"
  tags = {
    # Environment = "Demo"
    Owner       = lookup(data.external.me.result, "name")
    Source      = "terraform"
  }
}

# 1. DEV WORKSPACE CREATION

resource "azurerm_resource_group" "dev" {
  name     = "${local.prefix}-dev-rg"
  location = var.region
  tags = merge(local.tags, {
    Environment = "dev"
  })
}

resource "azurerm_databricks_workspace" "dev" {
  name                        = "${local.prefix}-dev-workspace"
  resource_group_name         = azurerm_resource_group.dev.name
  location                    = azurerm_resource_group.dev.location
  sku                         = "premium"
  managed_resource_group_name = "${local.prefix}-dev-workspace-rg"
  # tags                        = local.tags
  tags = merge(local.tags, {
    environment = "dev"
  })
}

output "databricks_host_dev" {
  value = "https://${azurerm_databricks_workspace.dev.workspace_url}/"
}

# 2. STAGING WORKSPACE CREATION

resource "azurerm_resource_group" "staging" {
  name     = "${local.prefix}-staging-rg"
  location = var.region
  tags = merge(local.tags, {
    Environment = "staging"
  })
}

resource "azurerm_databricks_workspace" "staging" {
  name                        = "${local.prefix}-staging-workspace"
  resource_group_name         = azurerm_resource_group.staging.name
  location                    = azurerm_resource_group.staging.location
  sku                         = "premium"
  managed_resource_group_name = "${local.prefix}-staging-workspace-rg"
  # tags                        = local.tags
  tags = merge(local.tags, {
    environment = "staging"
  })
}

output "databricks_host_staging" {
  value = "https://${azurerm_databricks_workspace.staging.workspace_url}/"
}

# 3. PROD WORKSPACE CREATION

resource "azurerm_resource_group" "prod" {
  name     = "${local.prefix}-prod-rg"
  location = var.region
  tags = merge(local.tags, {
    Environment = "prod"
  })
}

resource "azurerm_databricks_workspace" "prod" {
  name                        = "${local.prefix}-prod-workspace"
  resource_group_name         = azurerm_resource_group.prod.name
  location                    = azurerm_resource_group.prod.location
  sku                         = "premium"
  managed_resource_group_name = "${local.prefix}-prod-workspace-rg"
  # tags                        = local.tags
  tags = merge(local.tags, {
    environment = "prod"
  })
}

output "databricks_host_prod" {
  value = "https://${azurerm_databricks_workspace.prod.workspace_url}/"
}