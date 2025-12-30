# Azure Application Insights - Essential CLI Commands

## Application Insights Resource

### Create and Manage Application Insights
```bash
# Create Application Insights (workspace-based)
az monitor app-insights component create \
    --app <insights-name> \
    --location <location> \
    --resource-group <rg-name> \
    --workspace <log-analytics-workspace-id>

# Create Application Insights (classic)
az monitor app-insights component create \
    --app <insights-name> \
    --location <location> \
    --resource-group <rg-name> \
    --application-type web

# Create with specific kind
az monitor app-insights component create \
    --app <insights-name> \
    --location <location> \
    --resource-group <rg-name> \
    --kind web

# Show Application Insights details
az monitor app-insights component show \
    --app <insights-name> \
    --resource-group <rg-name>

# List Application Insights
az monitor app-insights component list \
    --resource-group <rg-name>

# Update Application Insights
az monitor app-insights component update \
    --app <insights-name> \
    --resource-group <rg-name> \
    --retention-time 90

# Delete Application Insights
az monitor app-insights component delete \
    --app <insights-name> \
    --resource-group <rg-name>
```

### Get Connection Information
```bash
# Get instrumentation key
az monitor app-insights component show \
    --app <insights-name> \
    --resource-group <rg-name> \
    --query instrumentationKey -o tsv

# Get connection string
az monitor app-insights component show \
    --app <insights-name> \
    --resource-group <rg-name> \
    --query connectionString -o tsv

# Get application ID
az monitor app-insights component show \
    --app <insights-name> \
    --resource-group <rg-name> \
    --query appId -o tsv
```

## Log Analytics Workspace

### Create and Manage Workspace
```bash
# Create Log Analytics workspace
az monitor log-analytics workspace create \
    --workspace-name <workspace-name> \
    --resource-group <rg-name> \
    --location <location>

# Show workspace details
az monitor log-analytics workspace show \
    --workspace-name <workspace-name> \
    --resource-group <rg-name>

# List workspaces
az monitor log-analytics workspace list \
    --resource-group <rg-name>

# Delete workspace
az monitor log-analytics workspace delete \
    --workspace-name <workspace-name> \
    --resource-group <rg-name>

# Get workspace ID
az monitor log-analytics workspace show \
    --workspace-name <workspace-name> \
    --resource-group <rg-name> \
    --query customerId -o tsv

# Get workspace key
az monitor log-analytics workspace get-shared-keys \
    --workspace-name <workspace-name> \
    --resource-group <rg-name> \
    --query primarySharedKey -o tsv
```

## API Keys

### Manage API Keys
```bash
# Create API key
az monitor app-insights api-key create \
    --app <insights-name> \
    --resource-group <rg-name> \
    --api-key <key-name> \
    --read-properties ReadTelemetry

# List API keys
az monitor app-insights api-key show \
    --app <insights-name> \
    --resource-group <rg-name> \
    --api-key <key-id>

# Delete API key
az monitor app-insights api-key delete \
    --app <insights-name> \
    --resource-group <rg-name> \
    --api-key <key-id>
```

## Querying Telemetry Data

### Run Queries
```bash
# Run KQL query
az monitor app-insights query \
    --app <insights-name> \
    --resource-group <rg-name> \
    --analytics-query "requests | summarize count() by bin(timestamp, 1h)"

# Query with time range
az monitor app-insights query \
    --app <insights-name> \
    --resource-group <rg-name> \
    --analytics-query "requests | where timestamp > ago(1h)" \
    --offset 1h

# Query exceptions
az monitor app-insights query \
    --app <insights-name> \
    --resource-group <rg-name> \
    --analytics-query "exceptions | top 10 by timestamp desc"

# Query custom events
az monitor app-insights query \
    --app <insights-name> \
    --resource-group <rg-name> \
    --analytics-query "customEvents | where name == 'UserLogin' | summarize count()"

# Query performance counters
az monitor app-insights query \
    --app <insights-name> \
    --resource-group <rg-name> \
    --analytics-query "performanceCounters | where name == 'Processor Time' | summarize avg(value)"
```

### Common KQL Queries
```bash
# Request count by result code
az monitor app-insights query \
    --app <insights-name> \
    --resource-group <rg-name> \
    --analytics-query "requests | summarize count() by resultCode"

# Average response time
az monitor app-insights query \
    --app <insights-name> \
    --resource-group <rg-name> \
    --analytics-query "requests | summarize avg(duration)"

# Failed requests
az monitor app-insights query \
    --app <insights-name> \
    --resource-group <rg-name> \
    --analytics-query "requests | where success == false"

# Dependency calls
az monitor app-insights query \
    --app <insights-name> \
    --resource-group <rg-name> \
    --analytics-query "dependencies | summarize count() by target"

# Page views
az monitor app-insights query \
    --app <insights-name> \
    --resource-group <rg-name> \
    --analytics-query "pageViews | summarize count() by name"
```

## Metrics

### Query Metrics
```bash
# Get available metrics
az monitor app-insights metrics show \
    --app <insights-name> \
    --resource-group <rg-name> \
    --metric requests/count

# Get metric with aggregation
az monitor app-insights metrics show \
    --app <insights-name> \
    --resource-group <rg-name> \
    --metric requests/duration \
    --aggregation avg

# Get metric for time range
az monitor app-insights metrics show \
    --app <insights-name> \
    --resource-group <rg-name> \
    --metric requests/count \
    --start-time 2024-01-01T00:00:00Z \
    --end-time 2024-01-01T23:59:59Z

# Get metric with interval
az monitor app-insights metrics show \
    --app <insights-name> \
    --resource-group <rg-name> \
    --metric requests/count \
    --interval PT1H

# List available metrics
az monitor app-insights metrics get-metadata \
    --app <insights-name> \
    --resource-group <rg-name>
```

## Alerts

### Create Alert Rules
```bash
# Create metric alert
az monitor metrics alert create \
    --name <alert-name> \
    --resource-group <rg-name> \
    --scopes /subscriptions/<sub-id>/resourceGroups/<rg-name>/providers/microsoft.insights/components/<insights-name> \
    --condition "avg requests/duration > 1000" \
    --description "Alert when average request duration exceeds 1 second"

# Create alert with action group
az monitor metrics alert create \
    --name <alert-name> \
    --resource-group <rg-name> \
    --scopes <app-insights-resource-id> \
    --condition "count requests/failed > 10" \
    --action <action-group-id>

# Show alert rule
az monitor metrics alert show \
    --name <alert-name> \
    --resource-group <rg-name>

# List alert rules
az monitor metrics alert list \
    --resource-group <rg-name>

# Update alert rule
az monitor metrics alert update \
    --name <alert-name> \
    --resource-group <rg-name> \
    --enabled false

# Delete alert rule
az monitor metrics alert delete \
    --name <alert-name> \
    --resource-group <rg-name>
```

### Action Groups
```bash
# Create action group
az monitor action-group create \
    --name <action-group-name> \
    --resource-group <rg-name> \
    --short-name <short-name>

# Add email receiver
az monitor action-group create \
    --name <action-group-name> \
    --resource-group <rg-name> \
    --action email admin admin@example.com

# Add webhook receiver
az monitor action-group create \
    --name <action-group-name> \
    --resource-group <rg-name> \
    --action webhook mywebhook https://example.com/webhook

# Show action group
az monitor action-group show \
    --name <action-group-name> \
    --resource-group <rg-name>

# List action groups
az monitor action-group list \
    --resource-group <rg-name>

# Delete action group
az monitor action-group delete \
    --name <action-group-name> \
    --resource-group <rg-name>
```

## Availability Tests

### Create Web Tests
```bash
# Note: Web tests are typically configured via portal or ARM templates
# CLI support is limited, but you can manage via az resource

# Create availability test (basic)
az resource create \
    --resource-type "microsoft.insights/webtests" \
    --name <webtest-name> \
    --resource-group <rg-name> \
    --location <location> \
    --properties @webtest.json
```

Example webtest.json:
```json
{
  "SyntheticMonitorId": "unique-id",
  "Name": "Home Page Test",
  "Enabled": true,
  "Frequency": 300,
  "Timeout": 30,
  "Kind": "ping",
  "Locations": [
    {
      "Id": "us-ca-sjc-azr"
    }
  ],
  "Configuration": {
    "WebTest": "<WebTest></WebTest>"
  }
}
```

## Integration with Azure Services

### Enable Application Insights on App Service
```bash
# Enable Application Insights for web app
az webapp config appsettings set \
    --name <app-name> \
    --resource-group <rg-name> \
    --settings APPINSIGHTS_INSTRUMENTATIONKEY=<instrumentation-key>

# Enable with connection string (recommended)
az webapp config appsettings set \
    --name <app-name> \
    --resource-group <rg-name> \
    --settings APPLICATIONINSIGHTS_CONNECTION_STRING=<connection-string>

# Enable for Function App
az functionapp config appsettings set \
    --name <function-app-name> \
    --resource-group <rg-name> \
    --settings APPINSIGHTS_INSTRUMENTATIONKEY=<instrumentation-key>
```

### Enable Diagnostic Settings
```bash
# Create diagnostic setting for App Service
az monitor diagnostic-settings create \
    --name <setting-name> \
    --resource <app-service-resource-id> \
    --workspace <log-analytics-workspace-id> \
    --logs '[{"category": "AppServiceHTTPLogs","enabled": true}]' \
    --metrics '[{"category": "AllMetrics","enabled": true}]'

# List diagnostic settings
az monitor diagnostic-settings list \
    --resource <resource-id>

# Delete diagnostic setting
az monitor diagnostic-settings delete \
    --name <setting-name> \
    --resource <resource-id>
```

## Continuous Export (Deprecated - Use Diagnostic Settings)

### Configure Data Export
```bash
# Note: Continuous export is deprecated. Use diagnostic settings instead.
# For exporting to storage account, use diagnostic settings:

az monitor diagnostic-settings create \
    --name export-to-storage \
    --resource <app-insights-resource-id> \
    --storage-account <storage-account-id> \
    --logs '[{"category": "Trace","enabled": true}]'
```

## Common Exam Scenarios

### Scenario: Set Up Application Insights for Web App
```bash
# 1. Create Log Analytics workspace
az monitor log-analytics workspace create \
    --workspace-name myworkspace \
    --resource-group myRG \
    --location eastus

# 2. Get workspace ID
WORKSPACE_ID=$(az monitor log-analytics workspace show \
    --workspace-name myworkspace \
    --resource-group myRG \
    --query id -o tsv)

# 3. Create Application Insights
az monitor app-insights component create \
    --app myappinsights \
    --location eastus \
    --resource-group myRG \
    --workspace $WORKSPACE_ID

# 4. Get connection string
CONNECTION_STRING=$(az monitor app-insights component show \
    --app myappinsights \
    --resource-group myRG \
    --query connectionString -o tsv)

# 5. Configure web app
az webapp config appsettings set \
    --name myapp \
    --resource-group myRG \
    --settings APPLICATIONINSIGHTS_CONNECTION_STRING="$CONNECTION_STRING"
```

### Scenario: Query Failed Requests and Create Alert
```bash
# 1. Query failed requests
az monitor app-insights query \
    --app myappinsights \
    --resource-group myRG \
    --analytics-query "requests | where success == false | summarize count() by bin(timestamp, 5m)"

# 2. Create action group
az monitor action-group create \
    --name alert-team \
    --resource-group myRG \
    --action email ops ops@example.com

# 3. Create alert rule
az monitor metrics alert create \
    --name high-error-rate \
    --resource-group myRG \
    --scopes /subscriptions/<sub-id>/resourceGroups/myRG/providers/microsoft.insights/components/myappinsights \
    --condition "count requests/failed > 10" \
    --window-size 5m \
    --evaluation-frequency 1m \
    --action /subscriptions/<sub-id>/resourceGroups/myRG/providers/microsoft.insights/actionGroups/alert-team
```

### Scenario: Enable Diagnostic Logging
```bash
# Create storage account for logs
az storage account create \
    --name diagstorage \
    --resource-group myRG \
    --sku Standard_LRS

# Enable diagnostic settings
az monitor diagnostic-settings create \
    --name export-logs \
    --resource /subscriptions/<sub-id>/resourceGroups/myRG/providers/Microsoft.Web/sites/myapp \
    --storage-account diagstorage \
    --logs '[
        {"category": "AppServiceHTTPLogs", "enabled": true},
        {"category": "AppServiceConsoleLogs", "enabled": true},
        {"category": "AppServiceAppLogs", "enabled": true}
    ]' \
    --metrics '[{"category": "AllMetrics", "enabled": true}]'
```
