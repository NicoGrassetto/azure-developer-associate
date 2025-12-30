# Azure App Service Deployment - Essential CLI Commands

## Deployment Methods

### Local Git Deployment
```bash
# Configure local git deployment
az webapp deployment source config-local-git \
    --name <app-name> \
    --resource-group <rg-name>

# Get deployment credentials
az webapp deployment list-publishing-credentials \
    --name <app-name> \
    --resource-group <rg-name>

# Set deployment user (for all apps in subscription)
az webapp deployment user set \
    --user-name <username> \
    --password <password>
```

### GitHub Deployment
```bash
# Configure GitHub deployment
az webapp deployment source config \
    --name <app-name> \
    --resource-group <rg-name> \
    --repo-url https://github.com/user/repo \
    --branch main \
    --manual-integration

# Configure GitHub Actions deployment
az webapp deployment github-actions add \
    --name <app-name> \
    --resource-group <rg-name> \
    --repo user/repo \
    --branch main \
    --runtime python \
    --runtime-version 3.11
```

### Azure DevOps Deployment
```bash
# Configure Azure DevOps deployment
az webapp deployment source config \
    --name <app-name> \
    --resource-group <rg-name> \
    --repo-url https://dev.azure.com/org/project/_git/repo \
    --branch main
```

### ZIP Deployment
```bash
# Deploy from ZIP file
az webapp deployment source config-zip \
    --name <app-name> \
    --resource-group <rg-name> \
    --src <path-to-zip-file>

# Deploy from ZIP file (async)
az webapp deploy \
    --name <app-name> \
    --resource-group <rg-name> \
    --src-path <path-to-zip-file> \
    --type zip \
    --async true
```

### FTP Deployment
```bash
# Get FTP deployment credentials
az webapp deployment list-publishing-credentials \
    --name <app-name> \
    --resource-group <rg-name>

# Show FTP deployment profile
az webapp deployment list-publishing-profiles \
    --name <app-name> \
    --resource-group <rg-name>
```

## Container Deployment

### Docker Container from Registry
```bash
# Create web app from Docker Hub
az webapp create \
    --name <app-name> \
    --resource-group <rg-name> \
    --plan <plan-name> \
    --deployment-container-image-name <image-name>

# Create web app from Azure Container Registry
az webapp create \
    --name <app-name> \
    --resource-group <rg-name> \
    --plan <plan-name> \
    --deployment-container-image-name <acr-name>.azurecr.io/<image-name>:<tag>

# Configure container settings
az webapp config container set \
    --name <app-name> \
    --resource-group <rg-name> \
    --docker-custom-image-name <acr-name>.azurecr.io/<image-name>:<tag> \
    --docker-registry-server-url https://<acr-name>.azurecr.io \
    --docker-registry-server-user <username> \
    --docker-registry-server-password <password>

# Enable continuous deployment from registry
az webapp deployment container config \
    --name <app-name> \
    --resource-group <rg-name> \
    --enable-cd true
```

## Deployment Slots with Deployment

### Deploy to Specific Slot
```bash
# Deploy ZIP to staging slot
az webapp deployment source config-zip \
    --name <app-name> \
    --resource-group <rg-name> \
    --slot staging \
    --src <path-to-zip-file>

# Configure GitHub deployment for slot
az webapp deployment source config \
    --name <app-name> \
    --resource-group <rg-name> \
    --slot staging \
    --repo-url https://github.com/user/repo \
    --branch develop \
    --manual-integration
```

## Deployment Configuration

### Deployment Settings
```bash
# Set deployment settings
az webapp config appsettings set \
    --name <app-name> \
    --resource-group <rg-name> \
    --settings SCM_DO_BUILD_DURING_DEPLOYMENT=true

# Configure build automation
az webapp config appsettings set \
    --name <app-name> \
    --resource-group <rg-name> \
    --settings ENABLE_ORYX_BUILD=true

# Set Python version for deployment
az webapp config appsettings set \
    --name <app-name> \
    --resource-group <rg-name> \
    --settings PYTHON_VERSION=3.11
```

### Kudu and SCM Settings
```bash
# Access Kudu console (in browser)
# https://<app-name>.scm.azurewebsites.net

# Get Kudu API endpoint
az webapp deployment list-publishing-credentials \
    --name <app-name> \
    --resource-group <rg-name> \
    --query scmUri
```

## Deployment History

### View Deployment History
```bash
# List deployments
az webapp deployment list-publishing-profiles \
    --name <app-name> \
    --resource-group <rg-name>

# Show deployment operations
az webapp deployment operation list \
    --name <app-name> \
    --resource-group <rg-name>
```

## Run Commands on App

### Remote Command Execution
```bash
# Run command on web app
az webapp ssh \
    --name <app-name> \
    --resource-group <rg-name>

# Run shell command
az webapp create-remote-connection \
    --name <app-name> \
    --resource-group <rg-name>
```

## Backup and Restore

### Backup Web App
```bash
# Create backup
az webapp config backup create \
    --resource-group <rg-name> \
    --webapp-name <app-name> \
    --backup-name <backup-name> \
    --container-url "<storage-sas-url>"

# List backups
az webapp config backup list \
    --resource-group <rg-name> \
    --webapp-name <app-name>

# Restore from backup
az webapp config backup restore \
    --resource-group <rg-name> \
    --webapp-name <app-name> \
    --backup-name <backup-name> \
    --container-url "<storage-sas-url>" \
    --target-name <target-app-name>
```

## WebJobs

### Manage WebJobs
```bash
# Note: WebJobs are typically managed via portal or direct deployment to wwwroot/App_Data/jobs

# List WebJobs (continuous)
az webapp webjob continuous list \
    --name <app-name> \
    --resource-group <rg-name>

# Start continuous WebJob
az webapp webjob continuous start \
    --name <app-name> \
    --resource-group <rg-name> \
    --webjob-name <webjob-name>

# Stop continuous WebJob
az webapp webjob continuous stop \
    --name <app-name> \
    --resource-group <rg-name> \
    --webjob-name <webjob-name>

# List triggered WebJobs
az webapp webjob triggered list \
    --name <app-name> \
    --resource-group <rg-name>

# Run triggered WebJob
az webapp webjob triggered run \
    --name <app-name> \
    --resource-group <rg-name> \
    --webjob-name <webjob-name>
```

## Deployment with ARM Templates

### Deploy Web App via ARM/Bicep
```bash
# Deploy ARM template
az deployment group create \
    --resource-group <rg-name> \
    --template-file template.json \
    --parameters parameters.json

# Deploy Bicep template
az deployment group create \
    --resource-group <rg-name> \
    --template-file main.bicep \
    --parameters appName=myapp
```

## Common Exam Scenarios

### Scenario: Blue-Green Deployment with Slots
```bash
# 1. Create production app
az webapp create \
    --name myapp \
    --resource-group myRG \
    --plan myplan

# 2. Create staging slot
az webapp deployment slot create \
    --name myapp \
    --resource-group myRG \
    --slot staging

# 3. Deploy new version to staging
az webapp deployment source config-zip \
    --name myapp \
    --resource-group myRG \
    --slot staging \
    --src app-v2.zip

# 4. Test staging: https://myapp-staging.azurewebsites.net

# 5. Swap staging to production
az webapp deployment slot swap \
    --name myapp \
    --resource-group myRG \
    --slot staging \
    --target-slot production
```

### Scenario: CI/CD with GitHub Actions
```bash
# Create web app
az webapp create \
    --name myapp \
    --resource-group myRG \
    --plan myplan \
    --runtime "PYTHON:3.11"

# Configure GitHub Actions
az webapp deployment github-actions add \
    --name myapp \
    --resource-group myRG \
    --repo username/repo \
    --branch main \
    --runtime python \
    --runtime-version 3.11

# This creates .github/workflows/main_myapp.yml in your repo
```

### Scenario: Deploy Container with Continuous Deployment
```bash
# Create ACR
az acr create \
    --name myacr \
    --resource-group myRG \
    --sku Basic

# Create web app with container
az webapp create \
    --name myapp \
    --resource-group myRG \
    --plan myplan \
    --deployment-container-image-name myacr.azurecr.io/myimage:latest

# Enable ACR admin
az acr update \
    --name myacr \
    --admin-enabled true

# Get ACR credentials
ACR_USER=$(az acr credential show --name myacr --query username -o tsv)
ACR_PASS=$(az acr credential show --name myacr --query passwords[0].value -o tsv)

# Configure web app container
az webapp config container set \
    --name myapp \
    --resource-group myRG \
    --docker-custom-image-name myacr.azurecr.io/myimage:latest \
    --docker-registry-server-url https://myacr.azurecr.io \
    --docker-registry-server-user $ACR_USER \
    --docker-registry-server-password $ACR_PASS

# Enable continuous deployment webhook
az webapp deployment container config \
    --name myapp \
    --resource-group myRG \
    --enable-cd true
```
