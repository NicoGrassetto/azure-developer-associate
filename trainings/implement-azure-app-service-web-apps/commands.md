# Azure App Service Web Apps - Essential CLI Commands

## App Service Plan Management

### Create and Manage App Service Plans
```bash
# Create App Service plan (Free tier)
az appservice plan create \
    --name <plan-name> \
    --resource-group <rg-name> \
    --sku F1

# Create App Service plan (Standard tier with Linux)
az appservice plan create \
    --name <plan-name> \
    --resource-group <rg-name> \
    --location <location> \
    --sku S1 \
    --is-linux

# Create App Service plan (Premium v3)
az appservice plan create \
    --name <plan-name> \
    --resource-group <rg-name> \
    --sku P1V3

# Show plan details
az appservice plan show \
    --name <plan-name> \
    --resource-group <rg-name>

# List App Service plans
az appservice plan list \
    --resource-group <rg-name>

# Update (scale up) App Service plan
az appservice plan update \
    --name <plan-name> \
    --resource-group <rg-name> \
    --sku S2

# Delete App Service plan
az appservice plan delete \
    --name <plan-name> \
    --resource-group <rg-name>
```

## Web App Management

### Create Web Apps
```bash
# Create web app
az webapp create \
    --name <app-name> \
    --resource-group <rg-name> \
    --plan <plan-name>

# Create web app with runtime
az webapp create \
    --name <app-name> \
    --resource-group <rg-name> \
    --plan <plan-name> \
    --runtime "PYTHON:3.11"

# Create web app with deployment from GitHub
az webapp create \
    --name <app-name> \
    --resource-group <rg-name> \
    --plan <plan-name> \
    --deployment-source-url https://github.com/user/repo \
    --deployment-source-branch main

# List runtimes available
az webapp list-runtimes --os linux
az webapp list-runtimes --os windows
```

### Web App Operations
```bash
# Show web app details
az webapp show \
    --name <app-name> \
    --resource-group <rg-name>

# List web apps
az webapp list \
    --resource-group <rg-name>

# Start web app
az webapp start \
    --name <app-name> \
    --resource-group <rg-name>

# Stop web app
az webapp stop \
    --name <app-name> \
    --resource-group <rg-name>

# Restart web app
az webapp restart \
    --name <app-name> \
    --resource-group <rg-name>

# Delete web app
az webapp delete \
    --name <app-name> \
    --resource-group <rg-name>

# Browse to web app
az webapp browse \
    --name <app-name> \
    --resource-group <rg-name>
```

## Configuration and Settings

### App Settings
```bash
# Set application settings
az webapp config appsettings set \
    --name <app-name> \
    --resource-group <rg-name> \
    --settings KEY1=VALUE1 KEY2=VALUE2

# List application settings
az webapp config appsettings list \
    --name <app-name> \
    --resource-group <rg-name>

# Delete application setting
az webapp config appsettings delete \
    --name <app-name> \
    --resource-group <rg-name> \
    --setting-names KEY1 KEY2
```

### Connection Strings
```bash
# Set connection string
az webapp config connection-string set \
    --name <app-name> \
    --resource-group <rg-name> \
    --connection-string-type SQLAzure \
    --settings MyDb="Server=...;Database=...;"

# List connection strings
az webapp config connection-string list \
    --name <app-name> \
    --resource-group <rg-name>

# Delete connection string
az webapp config connection-string delete \
    --name <app-name> \
    --resource-group <rg-name> \
    --setting-names MyDb
```

### General Configuration
```bash
# Configure web app (Python example)
az webapp config set \
    --name <app-name> \
    --resource-group <rg-name> \
    --startup-file "gunicorn --bind=0.0.0.0 --timeout 600 app:app"

# Enable/disable always on
az webapp config set \
    --name <app-name> \
    --resource-group <rg-name> \
    --always-on true

# Set minimum TLS version
az webapp config set \
    --name <app-name> \
    --resource-group <rg-name> \
    --min-tls-version 1.2

# Enable HTTP 2.0
az webapp config set \
    --name <app-name> \
    --resource-group <rg-name> \
    --http20-enabled true
```

## Scaling

### Manual Scaling
```bash
# Scale out (increase instance count)
az appservice plan update \
    --name <plan-name> \
    --resource-group <rg-name> \
    --number-of-workers 3
```

### Autoscaling
```bash
# Create autoscale rule
az monitor autoscale create \
    --resource-group <rg-name> \
    --resource <plan-resource-id> \
    --resource-type Microsoft.Web/serverFarms \
    --name autoscale-rules \
    --min-count 1 \
    --max-count 5 \
    --count 1

# Add scale out rule (CPU > 70%)
az monitor autoscale rule create \
    --resource-group <rg-name> \
    --autoscale-name autoscale-rules \
    --condition "Percentage CPU > 70 avg 5m" \
    --scale out 1

# Add scale in rule (CPU < 30%)
az monitor autoscale rule create \
    --resource-group <rg-name> \
    --autoscale-name autoscale-rules \
    --condition "Percentage CPU < 30 avg 5m" \
    --scale in 1
```

## Deployment Slots

### Manage Deployment Slots
```bash
# Create deployment slot
az webapp deployment slot create \
    --name <app-name> \
    --resource-group <rg-name> \
    --slot <slot-name>

# List deployment slots
az webapp deployment slot list \
    --name <app-name> \
    --resource-group <rg-name>

# Swap deployment slots
az webapp deployment slot swap \
    --name <app-name> \
    --resource-group <rg-name> \
    --slot <source-slot> \
    --target-slot production

# Swap with preview (multi-phase swap)
az webapp deployment slot swap \
    --name <app-name> \
    --resource-group <rg-name> \
    --slot staging \
    --action preview

# Complete swap
az webapp deployment slot swap \
    --name <app-name> \
    --resource-group <rg-name> \
    --slot staging \
    --action swap

# Auto-swap slot
az webapp deployment slot auto-swap \
    --name <app-name> \
    --resource-group <rg-name> \
    --slot staging \
    --auto-swap-slot production

# Delete deployment slot
az webapp deployment slot delete \
    --name <app-name> \
    --resource-group <rg-name> \
    --slot <slot-name>
```

## Custom Domains and SSL

### Custom Domain
```bash
# Add custom domain
az webapp config hostname add \
    --webapp-name <app-name> \
    --resource-group <rg-name> \
    --hostname www.example.com

# List hostnames
az webapp config hostname list \
    --webapp-name <app-name> \
    --resource-group <rg-name>

# Delete custom domain
az webapp config hostname delete \
    --webapp-name <app-name> \
    --resource-group <rg-name> \
    --hostname www.example.com
```

### SSL Certificates
```bash
# Upload SSL certificate
az webapp config ssl upload \
    --name <app-name> \
    --resource-group <rg-name> \
    --certificate-file <cert-file-path> \
    --certificate-password <password>

# Bind SSL certificate
az webapp config ssl bind \
    --name <app-name> \
    --resource-group <rg-name> \
    --certificate-thumbprint <thumbprint> \
    --ssl-type SNI

# List SSL certificates
az webapp config ssl list \
    --resource-group <rg-name>
```

## Logging and Diagnostics

### Configure Logging
```bash
# Enable application logging
az webapp log config \
    --name <app-name> \
    --resource-group <rg-name> \
    --application-logging filesystem

# Enable web server logging
az webapp log config \
    --name <app-name> \
    --resource-group <rg-name> \
    --web-server-logging filesystem

# Stream logs
az webapp log tail \
    --name <app-name> \
    --resource-group <rg-name>

# Download logs
az webapp log download \
    --name <app-name> \
    --resource-group <rg-name> \
    --log-file logs.zip
```

## Identity and Access

### Managed Identity
```bash
# Enable system-assigned managed identity
az webapp identity assign \
    --name <app-name> \
    --resource-group <rg-name>

# Show managed identity
az webapp identity show \
    --name <app-name> \
    --resource-group <rg-name>

# Assign user-assigned managed identity
az webapp identity assign \
    --name <app-name> \
    --resource-group <rg-name> \
    --identities <identity-resource-id>

# Remove managed identity
az webapp identity remove \
    --name <app-name> \
    --resource-group <rg-name>
```

## Common Exam Scenarios

### Scenario: Create Web App with Deployment Slot
```bash
# Create App Service plan
az appservice plan create \
    --name myplan \
    --resource-group myRG \
    --sku S1

# Create web app
az webapp create \
    --name myapp \
    --resource-group myRG \
    --plan myplan

# Create staging slot
az webapp deployment slot create \
    --name myapp \
    --resource-group myRG \
    --slot staging

# Swap staging to production
az webapp deployment slot swap \
    --name myapp \
    --resource-group myRG \
    --slot staging
```

### Scenario: Enable Managed Identity and Configure App Settings
```bash
# Enable managed identity
az webapp identity assign \
    --name myapp \
    --resource-group myRG

# Set app settings
az webapp config appsettings set \
    --name myapp \
    --resource-group myRG \
    --settings AZURE_CLIENT_ID="use-managed-identity"
```
