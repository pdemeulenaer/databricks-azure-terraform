terraform {
	backend "remote" {
		organization = "example-org-d50e3c" # org name from step 2.
		workspaces {
			name = "databricks-azure-terraform" # name for your app's state.
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