# databricks-azure-terraform

This tutorial describes the creation of Databricks workspaces within the Azure Cloud, following the Databricks documentation https://registry.terraform.io/providers/databricks/databricks/latest/docs/guides/azure-workspace

Tasks: 

* [Done]  create a multi-workspace platform (with adequate tags)

* TODO: provision Unity Catalog on top of the platform, following https://registry.terraform.io/providers/databricks/databricks/latest/docs/guides/unity-catalog-azure

Commands to run (if .tfvars exists)

terraform init
terraform plan -var-file="tutorial.tfvars"
terraform apply -var-file="tutorial.tfvars"