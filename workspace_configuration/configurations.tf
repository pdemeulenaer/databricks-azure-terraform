# POOL CREATION
resource "databricks_instance_pool" "smallest_nodes" {
  instance_pool_name = "Smallest Nodes (${data.databricks_current_user.me.alphanumeric})"
  min_idle_instances = 0
  max_capacity       = 10
  node_type_id       = data.databricks_node_type.smallest.id
  preloaded_spark_versions = [
    data.databricks_spark_version.latest.id
  ]

  idle_instance_autotermination_minutes = 20
}

# GLOBAL INIT SCRIPTS
resource "databricks_global_init_script" "init1" {
  source = "global_init_scripts/init.sh"
  name   = "test global init script"
}

# CLUSTER CREATIONS