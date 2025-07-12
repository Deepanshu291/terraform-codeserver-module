provider "azurerm" {
  features {
    
  }

  subscription_id = var.subcriptionID
}

resource "azurerm_resource_group" "RG" {
  name = "RG_vscode"
  location = "eastus"
}

resource "azurerm_container_group" "container" {
  name = "vscode-${var.username}"
  resource_group_name = azurerm_resource_group.RG.name
  location = azurerm_resource_group.RG.location
  os_type = "Linux"

  dns_name_label = "code-${var.username}"
  
  container {
    name = "code-server"
    image = "mcr.microsoft.com/vscode/devcontainers/python:3"
    memory = "1.5"
    cpu = "1"

    ports {
      port = 8080
      protocol = "TCP"
    }

    environment_variables = {
        PASSWORD = "code@123"
    }
  }
  ip_address_type = "Public"
}

output "container_url" {
    depends_on = [ azurerm_container_group.container ]
#   value = "${azurerm_container_group.container.fqdn}:8080"
    value = azurerm_container_group.container.fqdn
}