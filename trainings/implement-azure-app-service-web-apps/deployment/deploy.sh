#!/bin/bash
# Deploy Azure App Service infrastructure and upload static site content

set -e

RESOURCE_GROUP="counter-rg"
LOCATION="westeurope"
APP_SERVICE_PLAN="webAppServicePlan"
WEBAPP_NAME="counterWebApp"  # Use a fixed name to avoid duplicates

# Delete existing app if it exists
echo "Checking for existing app: $WEBAPP_NAME in resource group: $RESOURCE_GROUP..."
if az webapp show --name $WEBAPP_NAME --resource-group $RESOURCE_GROUP &> /dev/null; then
  echo "App exists. Deleting..."
  az webapp delete --name $WEBAPP_NAME --resource-group $RESOURCE_GROUP
  echo "Deleted existing app: $WEBAPP_NAME"
else
  echo "No existing app found."
fi

# Deploy Bicep infrastructure
az group create --name $RESOURCE_GROUP --location $LOCATION
az deployment group create \
  --resource-group $RESOURCE_GROUP \
  --template-file trainings/implement-azure-app-service-web-apps/deployment/infra/main.bicep \
  --parameters appServicePlanName=$APP_SERVICE_PLAN webAppName=$WEBAPP_NAME location=$LOCATION

# Zip and deploy static site content
cd trainings/implement-azure-app-service-web-apps/deployment/code
zip -r site.zip .
cd ../../../..

az webapp deploy \
  --resource-group $RESOURCE_GROUP \
  --name $WEBAPP_NAME \
  --src-path trainings/implement-azure-app-service-web-apps/deployment/code/site.zip \
  --type zip

echo "Deployment complete!"
echo "App URL: https://$WEBAPP_NAME.azurewebsites.net"
