# provider "azurerm" {
#   features {
    
#   }
# }
# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "=3.0.0"
#     }
#     docker = {
#       source  = "kreuzwerker/docker"
#       version = "3.6.2"
#     }
#   }
# }

# resource "azurerm_resource_group" "acrRG" {
#   name = "RG_vscode"
#   location = "eastus"
# }

# resource "azurerm_container_registry" "acr" {
#   name = "devxcoderserver"
#   resource_group_name = azurerm_resource_group.acrRG.name
#   sku = "Basic"
#   admin_enabled = true
#  location = azurerm_resource_group.acrRG.location
# }

# provider "docker" {
#   host = "unix:///var/run/docker.sock"
#   registry_auth {
#     address = azurerm_container_registry.acr.login_server
#     username = azurerm_container_registry.acr.admin_username
#     password = azurerm_container_registry.acr.admin_password
#   }
# }

# resource "docker_image" "codeserver" {
#     name = "${azurerm_container_registry.acr.login_server}/devxcoderserver:latest"
#     build {
#       context = "${path.module}"
#       dockerfile = "Dockerfile"
#     }
# }

# resource "docker_registry_image" "codeserver" {
#   name = docker_image.codeserver.name
# }