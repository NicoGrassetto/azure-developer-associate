#!/bin/bash

# Deploy the infrastructure
az deployment sub create \
  --name acr-deployment \
  --location eastus \
  --template-file ./infra/main.bicep

# Extract the registry name from the deployment output
REGISTRY_NAME=$(az deployment sub show --name acr-deployment --query properties.parameters.registryName.value --output tsv)

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

# Clean up resources
echo "Deleting resource group: az204-acr-rg"
az group delete --name az204-acr-rg --no-wait --yes