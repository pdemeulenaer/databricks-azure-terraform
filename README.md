# databricks-azure-terraform

This tutorial describes the provisioning of

* Databricks workspaces within the Azure Cloud, following the Databricks documentation https://registry.terraform.io/providers/databricks/databricks/latest/docs/guides/azure-workspace

* Unity Catalog on top of the platform, following https://registry.terraform.io/providers/databricks/databricks/latest/docs/guides/unity-catalog-azure

## Structure

To keep the creation of both logical entities separated, the configuration files supporting them are grouped into separated folders:

* workspace_creation

* unity_catalog

**A note on the state backend**: I chose to remotely store the state file into a backend located in Terraform Cloud (TFC). Hence to use this, one first has to subscribe to TFC (for free) and create a TFC workspace (within a TFC organisation, usually a default one is generated on subscription). In the settings of the workspace, tick the option for local execution (otherwise Terraform itself would run remotely, in TFC, instead of on your hardware. I keep it local run so that I do not need to configure Azure CLI in the TFC agent). Then, before running Terraform locally for the first time, run `Terraform login`, and enter a token that you could create within TFC (see this [example](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-login)).

Note that you can equally well store your state file on Azure ADLS. I chose TFC as it is cloud-agnostic.

## Tasks: 

* [DONE]  create a multi-workspace platform (with adequate dev/staging/prod tags)

* TODO: 

## Commands to run (if .tfvars exists)

terraform init
terraform plan -var-file="tutorial.tfvars"
terraform apply -var-file="tutorial.tfvars"