#!/bin/bash

# Script to deploy Azure resources using Bicep templates
# Usage: ./deploy.sh <resourceGroupName> <location> <environment>

# Set default values
RESOURCE_GROUP=${1:-"az204-resources-rg"}
LOCATION=${2:-"eastus"}
ENVIRONMENT=${3:-"dev"}

# Print deployment information
echo "Deploying Azure resources..."
echo "Resource Group: $RESOURCE_GROUP"
echo "Location: $LOCATION"
echo "Environment: $ENVIRONMENT"

# Check if resource group exists, create if not
if ! az group show --name $RESOURCE_GROUP &> /dev/null; then
    echo "Creating resource group $RESOURCE_GROUP..."
    az group create --name $RESOURCE_GROUP --location $LOCATION
else
    echo "Resource group $RESOURCE_GROUP already exists."
fi

# Deploy the Bicep template
echo "Starting deployment of main.bicep..."
DEPLOYMENT_NAME="main-deployment-$(date +%Y%m%d%H%M%S)"

az deployment group create \
  --name $DEPLOYMENT_NAME \
  --resource-group $RESOURCE_GROUP \
  --template-file main.bicep \
  --parameters location=$LOCATION environment=$ENVIRONMENT

# Check if deployment was successful
if [ $? -eq 0 ]; then
    echo "Deployment succeeded!"
    
    # Get outputs from the deployment
    echo "Retrieving connection strings and other outputs..."
    
    SERVICE_BUS_NAME=$(az deployment group show \
      --name $DEPLOYMENT_NAME \
      --resource-group $RESOURCE_GROUP \
      --query "properties.outputs.serviceBusName.value" \
      --output tsv)
      
    SERVICE_BUS_QUEUE=$(az deployment group show \
      --name $DEPLOYMENT_NAME \
      --resource-group $RESOURCE_GROUP \
      --query "properties.outputs.serviceBusQueueName.value" \
      --output tsv)
      
    STORAGE_QUEUE_NAME=$(az deployment group show \
      --name $DEPLOYMENT_NAME \
      --resource-group $RESOURCE_GROUP \
      --query "properties.outputs.storageQueueName.value" \
      --output tsv)
    
    echo "Service Bus namespace: $SERVICE_BUS_NAME"
    echo "Service Bus queue: $SERVICE_BUS_QUEUE"
    echo "Storage Queue: $STORAGE_QUEUE_NAME"
    
    echo "You can now use these resources in your applications."
else
    echo "Deployment failed."
    exit 1
fi