
resource "azurerm_storage_account" "example" {
  name                     = "${var.prefix}stor"
  resource_group_name      = "${data.azurerm_resource_group.example.name}"
  location                 = "${data.azurerm_resource_group.example.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Project = "Global Color",
    subProject = "JenkinsLab"
  }
}

resource "azurerm_storage_share" "example" {
  name                 = "jenkins-test-share"
  resource_group_name  = "${data.azurerm_resource_group.example.name}"
  storage_account_name = "${azurerm_storage_account.example.name}"
  quota                = 50
}


resource "azurerm_storage_share" "git-server-share" {
  name                 = "gitserver-test-share"
  resource_group_name  = "${data.azurerm_resource_group.example.name}"
  storage_account_name = "${azurerm_storage_account.example.name}"
  quota                = 50
}

resource "azurerm_container_group" "jenkins-container" {
  name                = "jenkins-container"
  location            = "${data.azurerm_resource_group.example.location}"
  resource_group_name = "${data.azurerm_resource_group.example.name}"
  ip_address_type     = "public"
  dns_name_label      = "jenkins-sandbox-das"
  os_type             = "Linux"

  container {
    name   = "jenkins-sandbox"
    image  = "jenkins/jenkins:lts"
    cpu    = "1.5"
    memory = "1.5"

    ports {
      port     = 8080
      protocol = "TCP"
    }

    ports {
      port     = 50000
      protocol = "TCP"
    }

    volume {
      name       = "jenkins-home"
      mount_path = "/var/jenkins_home"
      read_only  = false
      share_name = "${azurerm_storage_share.example.name}"

      storage_account_name = "${azurerm_storage_account.example.name}"
      storage_account_key  = "${azurerm_storage_account.example.primary_access_key}"
    }
  }
  container {
    name   = "git-server-sandbox"
    image  = "lerenn/git-server:latest"
    cpu    = "0.5"
    memory = "1.0"

    ports {
      port     = 22
      protocol = "TCP"
    }

    volume {
      name       = "var-git"
      mount_path = "/var/git"
      read_only  = false
      share_name = "${azurerm_storage_share.git-server-share.name}"

      storage_account_name = "${azurerm_storage_account.example.name}"
      storage_account_key  = "${azurerm_storage_account.example.primary_access_key}"
    }
  }

  tags = {
    Project = "Global Color",
    subProject = "JenkinsLab"
  }
}
