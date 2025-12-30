# Azure Service Bus & Queue Storage - Essential CLI Commands

## Service Bus Commands

### Namespace Management
```bash
# Create Service Bus namespace
az servicebus namespace create \
    --name <namespace-name> \
    --resource-group <rg-name> \
    --location <location> \
    --sku Standard

# Show namespace details
az servicebus namespace show \
    --name <namespace-name> \
    --resource-group <rg-name>

# Update namespace SKU
az servicebus namespace update \
    --name <namespace-name> \
    --resource-group <rg-name> \
    --sku Premium

# Delete namespace
az servicebus namespace delete \
    --name <namespace-name> \
    --resource-group <rg-name>
```

### Queue Management
```bash
# Create a queue
az servicebus queue create \
    --name <queue-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>

# Create queue with properties
az servicebus queue create \
    --name <queue-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name> \
    --max-size 2048 \
    --default-message-time-to-live P14D \
    --enable-dead-lettering-on-message-expiration true

# Show queue details
az servicebus queue show \
    --name <queue-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>

# Update queue
az servicebus queue update \
    --name <queue-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name> \
    --max-size 4096

# List queues
az servicebus queue list \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>

# Delete queue
az servicebus queue delete \
    --name <queue-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>
```

### Topic and Subscription Management
```bash
# Create a topic
az servicebus topic create \
    --name <topic-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>

# Create topic subscription
az servicebus topic subscription create \
    --name <subscription-name> \
    --topic-name <topic-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>

# Create subscription with filter
az servicebus topic subscription create \
    --name <subscription-name> \
    --topic-name <topic-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>

# Create subscription rule (SQL filter)
az servicebus topic subscription rule create \
    --name <rule-name> \
    --topic-name <topic-name> \
    --subscription-name <subscription-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name> \
    --filter-sql-expression "StoreId IN ('Store1','Store2')"

# List topic subscriptions
az servicebus topic subscription list \
    --topic-name <topic-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>

# Delete topic
az servicebus topic delete \
    --name <topic-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>
```

### Authorization Rules
```bash
# Create authorization rule for namespace
az servicebus namespace authorization-rule create \
    --name <rule-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name> \
    --rights Listen Send Manage

# Create authorization rule for queue
az servicebus queue authorization-rule create \
    --name <rule-name> \
    --queue-name <queue-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name> \
    --rights Listen Send

# Get connection string
az servicebus namespace authorization-rule keys list \
    --name <rule-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>

# Get queue connection string
az servicebus queue authorization-rule keys list \
    --name <rule-name> \
    --queue-name <queue-name> \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>
```

## Azure Queue Storage Commands

### Queue Management
```bash
# Create storage account (if needed)
az storage account create \
    --name <storage-account-name> \
    --resource-group <rg-name> \
    --location <location> \
    --sku Standard_LRS

# Create a queue
az storage queue create \
    --name <queue-name> \
    --account-name <storage-account-name>

# List queues
az storage queue list \
    --account-name <storage-account-name>

# Get queue metadata
az storage queue metadata show \
    --name <queue-name> \
    --account-name <storage-account-name>

# Delete queue
az storage queue delete \
    --name <queue-name> \
    --account-name <storage-account-name>
```

### Queue Message Operations
```bash
# Note: Message operations typically done via SDK, but CLI supports basic operations

# Get approximate message count
az storage queue metadata show \
    --name <queue-name> \
    --account-name <storage-account-name> \
    --query approximateMessageCount
```

## Common Exam Scenarios

### Scenario: Create Dead Letter Queue Setup
```bash
# Create main queue with dead letter on expiration
az servicebus queue create \
    --name orders-queue \
    --namespace-name <namespace-name> \
    --resource-group <rg-name> \
    --enable-dead-lettering-on-message-expiration true \
    --default-message-time-to-live PT10M
```

### Scenario: Assign RBAC for Service Bus
```bash
# Assign Service Bus Data Sender role
az role assignment create \
    --assignee <user-or-service-principal> \
    --role "Azure Service Bus Data Sender" \
    --scope <queue-or-topic-resource-id>

# Assign Service Bus Data Receiver role
az role assignment create \
    --assignee <user-or-service-principal> \
    --role "Azure Service Bus Data Receiver" \
    --scope <queue-or-topic-resource-id>
```

### Scenario: Configure Topic with Multiple Subscriptions
```bash
# Create topic
az servicebus topic create \
    --name orders-topic \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>

# Create subscriptions for different stores
az servicebus topic subscription create \
    --name store1-subscription \
    --topic-name orders-topic \
    --namespace-name <namespace-name> \
    --resource-group <rg-name>

# Add filter for Store1
az servicebus topic subscription rule create \
    --name Store1Filter \
    --topic-name orders-topic \
    --subscription-name store1-subscription \
    --namespace-name <namespace-name> \
    --resource-group <rg-name> \
    --filter-sql-expression "StoreId = 'Store1'"
```
