#!/bin/bash

# Exit on error
set -e

# Variables
resourceGroupName="demo-function-rg-2025"
location="eastus"
functionAppName="demo-function-app-2025"

# Create resource group if it doesn't exist
echo "Creating resource group $resourceGroupName..."
az group create --name $resourceGroupName --location $location

# Validate the deployment first
echo "Validating deployment..."
az deployment group what-if \
  --resource-group $resourceGroupName \
  --template-file infra/functions.bicep \
  --parameters functionAppName=$functionAppName

# Prompt for confirmation
read -p "Do you want to proceed with the deployment? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Deployment cancelled"
    exit 1
fi

# Deploy the function app
echo "Deploying Azure Function App..."
az deployment group create \
  --resource-group $resourceGroupName \
  --template-file infra/functions.bicep \
  --parameters functionAppName=$functionAppName

echo "Deployment completed successfully!"
echo "Function App URL: https://$functionAppName.azurewebsites.net"