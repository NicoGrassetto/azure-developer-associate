#!/bin/bash

# Set location
LOCATION="eastus"

# Generate a secure API key (or you could prompt for it)
API_KEY=$(openssl rand -base64 24)
echo "Generated secure API key (will not be displayed in logs)"

# Deploy the infrastructure
echo "Deploying infrastructure..."
az deployment sub create \
  --name container-deployment \
  --location $LOCATION \
  --template-file ./infra/main.bicep \
  --parameters apiKey=$API_KEY

# Extract the registry name and container FQDN from the deployment output
REGISTRY_NAME=$(az deployment sub show --name container-deployment --query properties.outputs.registryName.value --output tsv)
CONTAINER_FQDN=$(az deployment sub show --name container-deployment --query properties.outputs.containerFQDN.value --output tsv)

# Build and push the Docker image to ACR
echo "Building and pushing Docker image to ACR: $REGISTRY_NAME"
az acr build --image sample/hello-world:v1 --registry $REGISTRY_NAME --file Dockerfile .

# List the repositories in the Azure Container Registry
echo "Listing repositories in ACR: $REGISTRY_NAME"
az acr repository list --name $REGISTRY_NAME --output table

# Show tags for the repository
echo "Showing tags for repository sample/hello-world:"
az acr repository show-tags --name $REGISTRY_NAME \
    --repository sample/hello-world --output table

# Run the container image in ACR
echo "Running the container image in ACR:"
az acr run --registry $REGISTRY_NAME \
    --cmd '$Registry/sample/hello-world:v1' /dev/null

# Display ACI deployment information
echo "Azure Container Instance deployed successfully"
echo "Container Name: mycontainer"
echo "Container FQDN: $CONTAINER_FQDN"
echo "You can access the container at: http://$CONTAINER_FQDN"
echo "Note: A secure environment variable 'API_KEY' has been set in the container"

# Verify the container is running
echo "Checking container status:"
az container show --resource-group az204-aci-rg \
    --name mycontainer \
    --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" \
    --out table

# Wait for user to test the deployment
echo "Press Enter to clean up resources..."
read -p ""

# Clean up resources
echo "Cleaning up resources..."
echo "Deleting resource group: az204-acr-rg"
az group delete --name az204-acr-rg --no-wait --yes

echo "Deleting resource group: az204-aci-rg"
az group delete --name az204-aci-rg --no-wait --yes

echo "Cleanup completed. Resources will be deleted in the background."