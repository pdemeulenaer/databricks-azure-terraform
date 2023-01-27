variable "databricks_resource_id" {
  description = "The Azure resource ID for the databricks workspace deployment."
}

locals {
  resource_regex            = "(?i)subscriptions/(.+)/resourceGroups/(.+)/providers/Microsoft.Databricks/workspaces/(.+)"
  subscription_id           = regex(local.resource_regex, var.databricks_resource_id)[0]
  resource_group            = regex(local.resource_regex, var.databricks_resource_id)[1]
  databricks_workspace_name = regex(local.resource_regex, var.databricks_resource_id)[2]
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  databricks_workspace_host = data.azurerm_databricks_workspace.this.workspace_url
  databricks_workspace_id   = data.azurerm_databricks_workspace.this.workspace_id
  prefix                    = format("%.12s", replace(replace(replace(lower(data.azurerm_resource_group.this.name), "rg", ""), "-", ""), "databricks", ""))
}

data "azurerm_resource_group" "this" {
  name = local.resource_group
}

data "azurerm_client_config" "current" {
}

data "azurerm_databricks_workspace" "this" {
  name                = local.databricks_workspace_name
  resource_group_name = local.resource_group
}

variable "dev_url" {}

variable "staging_url" {}

variable "prod_url" {}

variable "github_token" {
  description = "personal access token from GitHub"
}

variable "git_repo_template" {
  description = "Git repo for the MLOps template"
}

variable "git_repo_de" {
  description = "Git repo for Data Engineering lectures from Databricks Academy"
}