terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

provider "azurerm" {
  features {
    
  }
  tenant_id = var.tenantID
  # subscription_id = var.subcriptionID
}

provider "docker" {
  host = "unix:///var/run/docker.sock" 
}



resource "docker_image" "codeS" {
  name = "codexdev"
  build {
    context = "${path.module}"
    dockerfile = "Dockerfile"
  }
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
    # image = "mcr.microsoft.com/vscode/devcontainers/python:3"
    image = docker_image.codeS.image_id
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