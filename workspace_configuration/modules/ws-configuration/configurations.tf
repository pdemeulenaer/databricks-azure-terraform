# Providers

terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.9.0"
      configuration_aliases = [ databricks.dev, databricks.staging ]  
    }
  }
}


# ============
# DEV PLATFORM
# ============

# POOL CREATION
resource "databricks_instance_pool" "dev_pool" {
  provider = databricks.dev
  instance_pool_name = "Smallest Nodes (${var.current_user_alphanumeric})" # "Smallest Nodes (${data.databricks_current_user.me.alphanumeric})"
  min_idle_instances = 0
  max_capacity       = 10
  node_type_id       = var.node_type_id # data.databricks_node_type.smallest.id
  preloaded_spark_versions = [
    var.spark_version_id # data.databricks_spark_version.latest.id
  ]

  idle_instance_autotermination_minutes = 20
}

# GLOBAL INIT SCRIPTS
resource "databricks_global_init_script" "init1" {
  provider = databricks.dev  
  source = "${path.module}/../../global_init_scripts/init.sh"
  name   = "test global init script"
  enabled = true # by default false
  position = 0 # position of Global init script (0=first) if multiple
}

# CLUSTER CREATIONS

# GITHUB INTEGRATION
# https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/git_credential

resource "databricks_git_credential" "github" {
  provider = databricks.dev
  git_username          = "pdemeulenaer"
  git_provider          = "gitHub"
  personal_access_token = var.github_token
}

# Cloning a repo
resource "databricks_repo" "nutter_in_home" {
  provider = databricks.dev
  url = var.git_repo
}


# # ================
# # STAGING PLATFORM
# # ================

# POOL CREATION
resource "databricks_instance_pool" "staging_pool" {
  provider = databricks.staging
  instance_pool_name = "Smallest Nodes (${var.current_user_alphanumeric})" # "Smallest Nodes (${data.databricks_current_user.me.alphanumeric})"
  min_idle_instances = 0
  max_capacity       = 10
  node_type_id       = var.node_type_id # data.databricks_node_type.smallest.id
  preloaded_spark_versions = [
    var.spark_version_id # data.databricks_spark_version.latest.id
  ]

  idle_instance_autotermination_minutes = 20
}

# # GLOBAL INIT SCRIPTS
# resource "databricks_global_init_script" "init1" {
#   provider = databricks.staging  
#   source = "${path.module}/../../global_init_scripts/init.sh"
#   name   = "test global init script"
#   enabled = true # by default false
#   position = 0 # position of Global init script (0=first) if multiple
# }

# # CLUSTER CREATIONS

# # GITHUB INTEGRATION
# # https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/git_credential

# resource "databricks_git_credential" "github" {
#   provider = databricks.staging
#   git_username          = "pdemeulenaer"
#   git_provider          = "gitHub"
#   personal_access_token = var.github_token
# }

# # Cloning a repo
# resource "databricks_repo" "nutter_in_home" {
#   provider = databricks.staging
#   url = var.git_repo
# }