# Azure Event Grid & Event Hubs - Essential CLI Commands

## Event Grid Commands

### Register Event Grid Provider
```bash
# Register the Event Grid resource provider
az provider register --namespace Microsoft.EventGrid

# Check registration status
az provider show --namespace Microsoft.EventGrid --query "registrationState"
```

### Custom Topics
```bash
# Create a custom topic
az eventgrid topic create \
    --name <topic-name> \
    --resource-group <rg-name> \
    --location <location>

# Get topic details
az eventgrid topic show \
    --name <topic-name> \
    --resource-group <rg-name>

# Get topic endpoint
az eventgrid topic show \
    --name <topic-name> \
    --resource-group <rg-name> \
    --query "endpoint" \
    --output tsv

# Get topic access keys
az eventgrid topic key list \
    --name <topic-name> \
    --resource-group <rg-name>

# Delete a topic
az eventgrid topic delete \
    --name <topic-name> \
    --resource-group <rg-name>
```

### Event Subscriptions
```bash
# Create event subscription (to webhook)
az eventgrid event-subscription create \
    --name <subscription-name> \
    --source-resource-id <topic-resource-id> \
    --endpoint <webhook-url>

# Create event subscription (to Azure Function)
az eventgrid event-subscription create \
    --name <subscription-name> \
    --source-resource-id <topic-resource-id> \
    --endpoint-type azurefunction \
    --endpoint <function-resource-id>

# List event subscriptions for a topic
az eventgrid event-subscription list \
    --source-resource-id <topic-resource-id>

# Delete event subscription
az eventgrid event-subscription delete \
    --name <subscription-name> \
    --source-resource-id <topic-resource-id>
```

## Event Hubs Commands

### Namespace Management
```bash
# Create Event Hubs namespace
az eventhubs namespace create \
    --name <namespace-name> \
    --resource-group <rg-name> \
    --location <location> \
    --sku Standard

# Show namespace details
az eventhubs namespace show \
    --name <namespace-name> \
    --resource-group <rg-name>

# Update namespace (scale)
az eventhubs namespace update \
    --name <namespace-name> \
    --resource-group <rg-name> \
    --capacity 2

# Delete namespace
az eventhubs namespace delete \
    --name <namespace-name> \
    --resource-group <rg-name>
```

### Event Hub Management
```bash
# Create an event hub
az eventhubs eventhub create \
    --name <eventhub-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name> \
    --partition-count 2 \
    --message-retention 1

# Show event hub details
az eventhubs eventhub show \
    --name <eventhub-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>

# Update event hub
az eventhubs eventhub update \
    --name <eventhub-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name> \
    --message-retention 3

# Delete event hub
az eventhubs eventhub delete \
    --name <eventhub-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>
```

### Consumer Groups
```bash
# Create consumer group
az eventhubs eventhub consumer-group create \
    --name <consumer-group-name> \
    --eventhub-name <eventhub-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>

# List consumer groups
az eventhubs eventhub consumer-group list \
    --eventhub-name <eventhub-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>
```

### Authorization Rules
```bash
# Create authorization rule for namespace
az eventhubs namespace authorization-rule create \
    --name <rule-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name> \
    --rights Listen Send

# Get connection string
az eventhubs namespace authorization-rule keys list \
    --name <rule-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>
```

## Common Exam Scenarios

### Scenario: Subscribe to Storage Account Events
```bash
# Get storage account resource ID
STORAGE_ID=$(az storage account show \
    --name <storage-name> \
    --resource-group <rg-name> \
    --query id --output tsv)

# Create event subscription for blob events
az eventgrid event-subscription create \
    --name <subscription-name> \
    --source-resource-id $STORAGE_ID \
    --endpoint <webhook-url> \
    --included-event-types Microsoft.Storage.BlobCreated
```

### Scenario: Assign RBAC for Event Hubs
```bash
# Assign Event Hubs Data Sender role
az role assignment create \
    --assignee <user-or-service-principal> \
    --role "Azure Event Hubs Data Sender" \
    --scope <eventhub-resource-id>

# Assign Event Hubs Data Receiver role
az role assignment create \
    --assignee <user-or-service-principal> \
    --role "Azure Event Hubs Data Receiver" \
    --scope <eventhub-resource-id>
```
