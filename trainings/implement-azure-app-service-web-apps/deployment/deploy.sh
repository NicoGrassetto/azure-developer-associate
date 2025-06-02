#!/bin/bash
# Deploy Azure App Service with static HTML content using az webapp up

set -e

RESOURCE_GROUP="counter-rg"
LOCATION="westeurope"
WEBAPP_NAME="counterWebApp"  # Use a fixed name to avoid duplicates

# Change to the code directory containing the HTML files
cd trainings/implement-azure-app-service-web-apps/deployment/code

# Deploy using az webapp up with --html flag
# This command will create the resource group, app service plan, and web app if they don't exist
# and deploy the HTML content in one step
az webapp up \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --name $WEBAPP_NAME \
  --html

echo "Deployment complete!"
echo "App URL: https://$WEBAPP_NAME.azurewebsites.net"
