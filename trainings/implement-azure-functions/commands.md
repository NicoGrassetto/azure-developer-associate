# Azure Functions - Essential CLI Commands

## Function App Management

### Create Function App
```bash
# Create storage account (required for function apps)
az storage account create \
    --name <storage-name> \
    --resource-group <rg-name> \
    --location <location> \
    --sku Standard_LRS

# Create function app (Consumption plan)
az functionapp create \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --storage-account <storage-name> \
    --consumption-plan-location <location> \
    --runtime python \
    --runtime-version 3.11 \
    --functions-version 4

# Create function app (Premium plan)
az functionapp plan create \
    --name <plan-name> \
    --resource-group <rg-name> \
    --location <location> \
    --sku EP1

az functionapp create \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --storage-account <storage-name> \
    --plan <plan-name> \
    --runtime python \
    --runtime-version 3.11 \
    --functions-version 4

# Create function app (Dedicated/App Service plan)
az functionapp create \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --storage-account <storage-name> \
    --plan <app-service-plan> \
    --runtime python \
    --runtime-version 3.11

# Create function app with Application Insights
az functionapp create \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --storage-account <storage-name> \
    --consumption-plan-location <location> \
    --runtime python \
    --runtime-version 3.11 \
    --functions-version 4 \
    --app-insights <insights-name>
```

### Function App Operations
```bash
# Show function app details
az functionapp show \
    --name <function-app-name> \
    --resource-group <rg-name>

# List function apps
az functionapp list \
    --resource-group <rg-name>

# Start function app
az functionapp start \
    --name <function-app-name> \
    --resource-group <rg-name>

# Stop function app
az functionapp stop \
    --name <function-app-name> \
    --resource-group <rg-name>

# Restart function app
az functionapp restart \
    --name <function-app-name> \
    --resource-group <rg-name>

# Delete function app
az functionapp delete \
    --name <function-app-name> \
    --resource-group <rg-name>
```

### List Available Runtimes
```bash
# List function app runtimes
az functionapp list-runtimes --os linux
az functionapp list-runtimes --os windows
```

## Configuration and Settings

### Application Settings
```bash
# Set application settings
az functionapp config appsettings set \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --settings KEY1=VALUE1 KEY2=VALUE2

# List application settings
az functionapp config appsettings list \
    --name <function-app-name> \
    --resource-group <rg-name>

# Delete application setting
az functionapp config appsettings delete \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --setting-names KEY1 KEY2
```

### Connection Strings
```bash
# Set connection string
az functionapp config connection-string set \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --connection-string-type SQLAzure \
    --settings MyDb="Server=...;Database=...;"
```

### Always On and Other Settings
```bash
# Enable always on (Premium/Dedicated plans only)
az functionapp config set \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --always-on true

# Set minimum TLS version
az functionapp config set \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --min-tls-version 1.2
```

## Deployment

### Deploy Function App
```bash
# Deploy from local directory (ZIP deployment)
func azure functionapp publish <function-app-name>

# Deploy from ZIP file
az functionapp deployment source config-zip \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --src <path-to-zip-file>

# Configure deployment from GitHub
az functionapp deployment source config \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --repo-url https://github.com/user/repo \
    --branch main \
    --manual-integration
```

### Deployment Slots
```bash
# Create deployment slot
az functionapp deployment slot create \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --slot <slot-name>

# List deployment slots
az functionapp deployment slot list \
    --name <function-app-name> \
    --resource-group <rg-name>

# Swap deployment slots
az functionapp deployment slot swap \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --slot <source-slot> \
    --target-slot production

# Delete deployment slot
az functionapp deployment slot delete \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --slot <slot-name>
```

## Function Management

### List Functions
```bash
# List functions in function app
az functionapp function show \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --function-name <function-name>

# Note: Individual function operations are typically done via Core Tools or portal
```

### Function Keys
```bash
# List function keys
az functionapp function keys list \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --function-name <function-name>

# List host keys (master keys)
az functionapp keys list \
    --name <function-app-name> \
    --resource-group <rg-name>

# Set function key
az functionapp function keys set \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --function-name <function-name> \
    --key-name <key-name> \
    --key-value <key-value>
```

## Managed Identity

### Configure Managed Identity
```bash
# Enable system-assigned managed identity
az functionapp identity assign \
    --name <function-app-name> \
    --resource-group <rg-name>

# Show managed identity
az functionapp identity show \
    --name <function-app-name> \
    --resource-group <rg-name>

# Assign user-assigned managed identity
az functionapp identity assign \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --identities <identity-resource-id>

# Remove managed identity
az functionapp identity remove \
    --name <function-app-name> \
    --resource-group <rg-name>
```

## CORS Configuration

### Configure CORS
```bash
# Add allowed origins
az functionapp cors add \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --allowed-origins https://example.com

# Show CORS settings
az functionapp cors show \
    --name <function-app-name> \
    --resource-group <rg-name>

# Remove allowed origin
az functionapp cors remove \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --allowed-origins https://example.com

# Remove all CORS origins
az functionapp cors remove \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --allowed-origins '*'
```

## VNet Integration

### Configure VNet Integration
```bash
# Add VNet integration
az functionapp vnet-integration add \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --vnet <vnet-name> \
    --subnet <subnet-name>

# List VNet integrations
az functionapp vnet-integration list \
    --name <function-app-name> \
    --resource-group <rg-name>

# Remove VNet integration
az functionapp vnet-integration remove \
    --name <function-app-name> \
    --resource-group <rg-name>
```

## Logging and Monitoring

### Configure Logging
```bash
# Enable application logging
az functionapp log config \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --application-logging true

# Stream logs
az functionapp log tail \
    --name <function-app-name> \
    --resource-group <rg-name>

# Download logs
az functionapp log download \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --log-file logs.zip
```

### Application Insights
```bash
# Enable Application Insights
az functionapp config appsettings set \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --settings APPINSIGHTS_INSTRUMENTATIONKEY=<key>

# Create Application Insights instance
az monitor app-insights component create \
    --app <insights-name> \
    --location <location> \
    --resource-group <rg-name>

# Get instrumentation key
az monitor app-insights component show \
    --app <insights-name> \
    --resource-group <rg-name> \
    --query instrumentationKey
```

## Azure Functions Core Tools (Local Development)

### Core Tools Commands
```bash
# Initialize new function app project
func init <project-name> --python

# Create new function
func new --name <function-name> --template "HTTP trigger"

# Run function app locally
func start

# Run function app with specific port
func start --port 7072

# Publish to Azure
func azure functionapp publish <function-app-name>

# Fetch app settings from Azure
func azure functionapp fetch-app-settings <function-app-name>

# List functions in remote function app
func azure functionapp list-functions <function-app-name>
```

## Common Exam Scenarios

### Scenario: Create HTTP Trigger Function with Managed Identity
```bash
# Create storage account
az storage account create \
    --name mystorageacct \
    --resource-group myRG \
    --sku Standard_LRS

# Create function app
az functionapp create \
    --name myfunctionapp \
    --resource-group myRG \
    --storage-account mystorageacct \
    --consumption-plan-location eastus \
    --runtime python \
    --runtime-version 3.11 \
    --functions-version 4

# Enable managed identity
az functionapp identity assign \
    --name myfunctionapp \
    --resource-group myRG

# Get principal ID for role assignment
PRINCIPAL_ID=$(az functionapp identity show \
    --name myfunctionapp \
    --resource-group myRG \
    --query principalId -o tsv)
```

### Scenario: Timer Trigger with App Insights
```bash
# Create Application Insights
az monitor app-insights component create \
    --app myinsights \
    --location eastus \
    --resource-group myRG

# Get instrumentation key
INSIGHTS_KEY=$(az monitor app-insights component show \
    --app myinsights \
    --resource-group myRG \
    --query instrumentationKey -o tsv)

# Create function app with App Insights
az functionapp create \
    --name myfunctionapp \
    --resource-group myRG \
    --storage-account mystorageacct \
    --consumption-plan-location eastus \
    --runtime python \
    --runtime-version 3.11 \
    --functions-version 4

# Set App Insights key
az functionapp config appsettings set \
    --name myfunctionapp \
    --resource-group myRG \
    --settings APPINSIGHTS_INSTRUMENTATIONKEY=$INSIGHTS_KEY
```

### Scenario: Durable Functions Setup
```bash
# Create function app (Durable requires storage)
az functionapp create \
    --name mydurablefunc \
    --resource-group myRG \
    --storage-account mystorageacct \
    --consumption-plan-location eastus \
    --runtime python \
    --runtime-version 3.11 \
    --functions-version 4

# Deploy durable function (using core tools)
# func azure functionapp publish mydurablefunc
```
