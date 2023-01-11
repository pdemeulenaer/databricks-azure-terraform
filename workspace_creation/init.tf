terraform {
	backend "remote" {
		organization = "example-org-d50e3c" # org name in Terraform Cloud
		workspaces {
			name = "databricks-azure-terraform" # name of the workspace containing the state file
		}
	}    
    required_providers {
        azurerm = "~> 2.33"
        random  = "~> 2.2"
    }
}

provider "azurerm" {
    features {}
}