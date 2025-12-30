# Azure Cosmos DB - Essential CLI Commands

## Account Management

### Create Cosmos DB Account
```bash
# Create account with SQL API
az cosmosdb create \
    --name <account-name> \
    --resource-group <rg-name> \
    --locations regionName=<region> failoverPriority=0 \
    --default-consistency-level Session

# Create account with specific consistency level
az cosmosdb create \
    --name <account-name> \
    --resource-group <rg-name> \
    --locations regionName=<region> \
    --default-consistency-level Strong

# Create multi-region account
az cosmosdb create \
    --name <account-name> \
    --resource-group <rg-name> \
    --locations regionName=eastus failoverPriority=0 \
               regionName=westus failoverPriority=1 \
    --enable-multiple-write-locations true
```

### Account Operations
```bash
# Show account details
az cosmosdb show \
    --name <account-name> \
    --resource-group <rg-name>

# Update account consistency
az cosmosdb update \
    --name <account-name> \
    --resource-group <rg-name> \
    --default-consistency-level BoundedStaleness \
    --max-staleness-prefix 100 \
    --max-interval 5

# List connection strings
az cosmosdb keys list \
    --name <account-name> \
    --resource-group <rg-name> \
    --type connection-strings

# List account keys
az cosmosdb keys list \
    --name <account-name> \
    --resource-group <rg-name>

# List read-only keys
az cosmosdb keys list \
    --name <account-name> \
    --resource-group <rg-name> \
    --type read-only-keys

# Regenerate account key
az cosmosdb keys regenerate \
    --name <account-name> \
    --resource-group <rg-name> \
    --key-kind primary

# Delete account
az cosmosdb delete \
    --name <account-name> \
    --resource-group <rg-name>
```

## Database Management

### SQL API Database Operations
```bash
# Create database
az cosmosdb sql database create \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --name <database-name>

# Create database with shared throughput
az cosmosdb sql database create \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --name <database-name> \
    --throughput 400

# Create database with autoscale
az cosmosdb sql database create \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --name <database-name> \
    --max-throughput 4000

# Show database
az cosmosdb sql database show \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --name <database-name>

# List databases
az cosmosdb sql database list \
    --account-name <account-name> \
    --resource-group <rg-name>

# Delete database
az cosmosdb sql database delete \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --name <database-name>
```

## Container Management

### Create Containers
```bash
# Create container with partition key
az cosmosdb sql container create \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --database-name <database-name> \
    --name <container-name> \
    --partition-key-path "/category"

# Create container with dedicated throughput
az cosmosdb sql container create \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --database-name <database-name> \
    --name <container-name> \
    --partition-key-path "/id" \
    --throughput 400

# Create container with autoscale
az cosmosdb sql container create \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --database-name <database-name> \
    --name <container-name> \
    --partition-key-path "/userId" \
    --max-throughput 4000

# Create container with unique key policy
az cosmosdb sql container create \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --database-name <database-name> \
    --name <container-name> \
    --partition-key-path "/id" \
    --unique-key-policy '{"uniqueKeys":[{"paths":["/email"]}]}'

# Create container with TTL
az cosmosdb sql container create \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --database-name <database-name> \
    --name <container-name> \
    --partition-key-path "/id" \
    --ttl 3600
```

### Container Operations
```bash
# Show container
az cosmosdb sql container show \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --database-name <database-name> \
    --name <container-name>

# List containers
az cosmosdb sql container list \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --database-name <database-name>

# Update container throughput
az cosmosdb sql container throughput update \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --database-name <database-name> \
    --name <container-name> \
    --throughput 800

# Migrate to autoscale
az cosmosdb sql container throughput migrate \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --database-name <database-name> \
    --name <container-name> \
    --throughput-type autoscale

# Delete container
az cosmosdb sql container delete \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --database-name <database-name> \
    --name <container-name>
```

## Regional and Failover Configuration

### Multi-Region Setup
```bash
# Add region to account
az cosmosdb update \
    --name <account-name> \
    --resource-group <rg-name> \
    --locations regionName=eastus failoverPriority=0 \
               regionName=westus failoverPriority=1

# Enable multiple write locations
az cosmosdb update \
    --name <account-name> \
    --resource-group <rg-name> \
    --enable-multiple-write-locations true

# List failover priorities
az cosmosdb failover-priority-change \
    --name <account-name> \
    --resource-group <rg-name> \
    --failover-policies eastus=0 westus=1
```

## RBAC and Security

### Built-in Role Assignments
```bash
# Assign Cosmos DB Built-in Data Contributor role
az cosmosdb sql role assignment create \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --role-definition-id 00000000-0000-0000-0000-000000000002 \
    --principal-id <principal-id> \
    --scope "/"

# Assign Cosmos DB Built-in Data Reader role
az cosmosdb sql role assignment create \
    --account-name <account-name> \
    --resource-group <rg-name> \
    --role-definition-id 00000000-0000-0000-0000-000000000001 \
    --principal-id <principal-id> \
    --scope "/"

# List role assignments
az cosmosdb sql role assignment list \
    --account-name <account-name> \
    --resource-group <rg-name>
```

## Common Exam Scenarios

### Scenario: Create Partitioned Container for E-commerce
```bash
# Create account
az cosmosdb create \
    --name ecommerce-cosmos \
    --resource-group myRG \
    --locations regionName=eastus

# Create database with shared throughput
az cosmosdb sql database create \
    --account-name ecommerce-cosmos \
    --resource-group myRG \
    --name products-db \
    --throughput 400

# Create container with category partition key
az cosmosdb sql container create \
    --account-name ecommerce-cosmos \
    --resource-group myRG \
    --database-name products-db \
    --name products \
    --partition-key-path "/category"
```

### Scenario: Configure Strong Consistency with Multi-Region
```bash
# Create multi-region account with strong consistency
az cosmosdb create \
    --name global-cosmos \
    --resource-group myRG \
    --locations regionName=eastus failoverPriority=0 \
               regionName=westus failoverPriority=1 \
    --default-consistency-level Strong
```
