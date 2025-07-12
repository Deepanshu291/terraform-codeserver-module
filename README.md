# Azure Container Instance Code Server

This Terraform module deploys a VS Code Server environment using Azure Container Instances (ACI), providing a cloud-based development environment accessible through your web browser.

## 🏗️ Architecture

This module creates the following Azure resources:

- **Resource Group** - Container for all resources
- **Container Group** - Azure Container Instance hosting Code Server
- **Public IP** - Direct internet access with DNS label
- **VS Code Server** - Browser-based development environment

## ☁️ What is Code Server?

Code Server is VS Code running on a remote server, accessible through the browser. This setup provides:

- ✅ **Consistent dev environment** across any device
- ✅ **Pre-configured Python environment** 
- ✅ **No local installation required**
- ✅ **Cost-effective** - pay only when running
- ✅ **Fast deployment** - ready in minutes

## 📋 Prerequisites

Before using this module, ensure you have:

1. **Azure CLI** installed and configured
   ```bash
   # Install Azure CLI (Ubuntu/Debian)
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   
   # Login to Azure
   az login
   ```

2. **Terraform** installed (version >= 1.0)
   ```bash
   # Install Terraform
   wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
   unzip terraform_1.6.0_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   terraform --version
   ```

3. **Azure Subscription** with Container Instance permissions

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/Deepanshu291/terraform-codeserver.git
cd terraform-codeserver/codeserver
```

### 2. Configure Variables
Create or modify `terraform.tfvars` file:

```hcl
# Required Variables
subcriptionID = "your-azure-subscription-id"

# Optional Variables (defaults provided)
username = "deepanshu"  # Used for container and DNS naming
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Plan the Deployment
```bash
terraform plan
```

### 5. Deploy the Container
```bash
terraform apply
```

When prompted, type `yes` to confirm the deployment.

### 6. Access Your Code Server
After deployment, get the URL:
```bash
terraform output container_url
```

Open the URL in your browser and use password: `code@123`

## 📁 Project Structure

```
codeserver/
├── main.tf              # Main Terraform configuration
├── var.tf               # Variable definitions
├── terraform.tfvars     # Variable values (customize this)
├── terraform.tfstate    # Terraform state file (auto-generated)
└── README.md            # This file
```

## ⚙️ Configuration Variables

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|----------|
| `subcriptionID` | Azure subscription ID | string | `""` | Yes |
| `username` | Username for container naming | string | `"deepanshu"` | No |

## 🐳 Container Configuration

- **Base Image**: `mcr.microsoft.com/vscode/devcontainers/python:3`
- **Resources**: 1.5GB RAM, 1 CPU
- **Port**: 8080 (HTTP)
- **Password**: `code@123` ⚠️ *Change this in production!*
- **Location**: East US
- **DNS**: `code-{username}.eastus.azurecontainer.io`

## 🌐 Network Access

The container is deployed with:
- **Public IP**: Direct internet access
- **DNS Label**: Friendly domain name
- **Protocol**: HTTP (port 8080)
- **Access**: Open to the internet ⚠️

## 📤 Outputs

After successful deployment:

- **Container URL**: Direct link to your Code Server instance

```bash
# View the URL
terraform output container_url

# Example output: code-deepanshu.eastus.azurecontainer.io
```

## 🔧 Demo Commands

### Basic Operations
```bash
# Initialize the project
terraform init

# Validate configuration
terraform validate

# Format Terraform files
terraform fmt

# Plan changes
terraform plan -var-file="terraform.tfvars"

# Apply changes
terraform apply -var-file="terraform.tfvars"

# Show current state
terraform show

# Get the container URL
terraform output container_url

# Check container status
az container show --resource-group RG_vscode --name vscode-deepanshu

# View container logs
az container logs --resource-group RG_vscode --name vscode-deepanshu

# Destroy infrastructure
terraform destroy
```

### Advanced Operations
```bash
# Apply with auto-approve
terraform apply -auto-approve

# Plan with specific target
terraform plan -target=azurerm_container_group.container

# Import existing container group
terraform import azurerm_container_group.container /subscriptions/{subscription-id}/resourceGroups/RG_vscode/providers/Microsoft.ContainerInstance/containerGroups/vscode-{username}

# Refresh state
terraform refresh

# Show planned changes in JSON
terraform show -json terraform.tfplan
```

## 🔍 Troubleshooting

### Common Issues

1. **Authentication Error**
   ```bash
   az login
   az account set --subscription "your-subscription-id"
   ```

2. **Container Not Starting**
   ```bash
   # Check container logs
   az container logs --resource-group RG_vscode --name vscode-{username}
   
   # Check container status
   az container show --resource-group RG_vscode --name vscode-{username} --query instanceView.state
   ```

3. **Can't Access Code Server**
   - Verify the container is running
   - Check if port 8080 is accessible
   - Ensure DNS resolution is working

4. **Resource Already Exists**
   ```bash
   terraform import azurerm_resource_group.RG /subscriptions/{id}/resourceGroups/RG_vscode
   ```

### Useful Debugging Commands
```bash
# Enable detailed logging
export TF_LOG=DEBUG
terraform apply

# Check Azure container instances
az container list --output table

# Test connectivity
curl -I http://code-{username}.eastus.azurecontainer.io:8080

# Monitor container events
az container attach --resource-group RG_vscode --name vscode-{username}
```

## 🔒 Security Considerations

⚠️ **Important Security Notes:**

1. **Change Default Password**: The password `code@123` is for demo purposes only
2. **Public Access**: Container is accessible from the internet
3. **No HTTPS**: Traffic is not encrypted by default
4. **Authentication**: Only password-based authentication

### Recommended Security Improvements

```bash
# Use environment variables for secrets
export TF_VAR_password="your-secure-password"

# Consider using Azure Key Vault
# Implement IP restrictions
# Add HTTPS/TLS termination
# Use Azure AD authentication
```

### Enhanced Security Configuration
```hcl
# Example: Restrict access by IP
# Add this to your main.tf for production use
resource "azurerm_network_profile" "container_profile" {
  # Configure network restrictions
}
```

## 💰 Cost Optimization

- **Pay-per-use**: You're only charged when the container is running
- **Resource sizing**: Adjust memory/CPU based on your needs
- **Auto-shutdown**: Consider implementing scheduled start/stop

```bash
# Stop container to save costs
az container stop --resource-group RG_vscode --name vscode-{username}

# Start container when needed
az container start --resource-group RG_vscode --name vscode-{username}
```

## 🎯 Use Cases

Perfect for:
- **Remote development** from any device
- **Temporary development environments**
- **Code reviews and collaboration**
- **Learning and experimentation**
- **CI/CD pipeline testing**

## 🔧 Customization

### Changing the Base Image
```hcl
# In main.tf, modify the image:
image = "codercom/code-server:latest"  # Alternative Code Server image
# or
image = "mcr.microsoft.com/vscode/devcontainers/javascript-node:16"  # Node.js environment
```

### Adding Environment Variables
```hcl
environment_variables = {
  PASSWORD = "your-secure-password"
  DOCKER_USER = "coder"
  SHELL = "/bin/bash"
}
```

### Resource Adjustment
```hcl
memory = "2.0"    # Increase to 2GB
cpu = "1.5"       # Increase CPU allocation
```

## 🧹 Cleanup

To destroy all created resources:

```bash
terraform destroy
```

**Note**: This will permanently delete the container and any unsaved work inside it.

## 📊 Monitoring

Monitor your Code Server instance:

```bash
# Container metrics
az monitor metrics list --resource /subscriptions/{subscription-id}/resourceGroups/RG_vscode/providers/Microsoft.ContainerInstance/containerGroups/vscode-{username}

# Resource usage
az container exec --resource-group RG_vscode --name vscode-{username} --exec-command "/bin/bash"
```

## 🚀 Next Steps

After deployment, you can:

1. **Install VS Code extensions** through the web interface
2. **Clone your repositories** directly in the browser
3. **Set up your development tools** (git, npm, pip, etc.)
4. **Configure your workspace** settings and preferences

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

This project is licensed under the MIT License.

## 🆘 Support

For issues and questions:
- Create an issue in the GitHub repository
- Check the troubleshooting section above
- Refer to [Azure Container Instances Documentation](https://docs.microsoft.com/en-us/azure/container-instances/)
- Visit [Code Server Documentation](https://coder.com/docs/code-server/)

---

**Last Updated**: July 2025  
**Terraform Version**: >= 1.0  
**Azure Provider Version**: Latest stable  
**Code Server**: Browser-based VS Code
