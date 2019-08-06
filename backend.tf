terraform {
  backend "azurerm" {
    storage_account_name = "terrsandbacking"
    container_name       = "backingstore"
    key                  = "sandbox.terraform.tfstate"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
    # access_key = "${var.backend-storage-access-key}"
  }
}

provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.32.1"
  tenant_id = "${var.tenant-id}"
  skip_provider_registration = true
}