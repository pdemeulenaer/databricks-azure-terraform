# Common part

resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

data "azurerm_client_config" "current" {
}

# Causing error with Azure 
# data "external" "me" {
#   program = ["az", "account", "show", "--query", "user"]
# }

locals {
  # prefix = "databricks-tf-${random_string.naming.result}"
  prefix = "db-tf"
  tags = {
    # Environment = "Demo"
    # Owner       = lookup(data.external.me.result, "name")
    Source      = "terraform"
  }
}

# 1. DEV WORKSPACE CREATION
# =========================

resource "azurerm_resource_group" "dev" {
  name     = "${local.prefix}-dev-rg"
  location = var.region
  tags = merge(local.tags, {
    environment = "dev"
  })
}

resource "azurerm_databricks_workspace" "dev" {
  name                        = "${local.prefix}-dev-ws"
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

resource "local_file" "dev_ws_url" {
    content  = "dev_url=\"https://${azurerm_databricks_workspace.dev.workspace_url}/\""
    filename = "dev_ws.tfvars"
}


# 2. STAGING WORKSPACE CREATION
# =============================

resource "azurerm_resource_group" "staging" {
  name     = "${local.prefix}-staging-rg"
  location = var.region
  tags = merge(local.tags, {
    environment = "staging"
  })
}

resource "azurerm_databricks_workspace" "staging" {
  name                        = "${local.prefix}-staging-ws"
  resource_group_name         = azurerm_resource_group.staging.name
  location                    = azurerm_resource_group.staging.location
  sku                         = "premium"
  managed_resource_group_name = "${local.prefix}-staging-ws-rg"
  # tags                        = local.tags
  tags = merge(local.tags, {
    environment = "staging"
  })
}

output "databricks_host_staging" {
  value = "https://${azurerm_databricks_workspace.staging.workspace_url}/"
}

resource "local_file" "staging_ws_url" {
    content  = "staging_url=\"https://${azurerm_databricks_workspace.staging.workspace_url}/\""
    filename = "staging_ws.tfvars"
}


# 3. PROD WORKSPACE CREATION
# ==========================

resource "azurerm_resource_group" "prod" {
  name     = "${local.prefix}-prod-rg"
  location = var.region
  tags = merge(local.tags, {
    environment = "prod"
  })
}

resource "azurerm_databricks_workspace" "prod" {
  name                        = "${local.prefix}-prod-ws"
  resource_group_name         = azurerm_resource_group.prod.name
  location                    = azurerm_resource_group.prod.location
  sku                         = "premium"
  managed_resource_group_name = "${local.prefix}-prod-ws-rg"
  # tags                        = local.tags
  tags = merge(local.tags, {
    environment = "prod"
  })
}

output "databricks_host_prod" {
  value = "https://${azurerm_databricks_workspace.prod.workspace_url}/"
}

resource "local_file" "prod_ws_url" {
    content  = "prod_url=\"https://${azurerm_databricks_workspace.prod.workspace_url}/\""
    filename = "prod_ws.tfvars"
}