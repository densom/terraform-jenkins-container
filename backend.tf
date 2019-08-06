terraform {
  backend "azurerm" {
    storage_account_name = "terrsandbacking"
    container_name       = "backingstore"
    key                  = "sandbox.terraform.tfstate"
  }
}

provider "azurerm" {
  version = "=1.32.1"
  tenant_id = "${var.tenant-id}"
  skip_provider_registration = true
}