# Azure Blob Storage - Essential CLI Commands

## Storage Account Management

### Create Storage Account
```bash
# Create storage account
az storage account create \
    --name <storage-account-name> \
    --resource-group <rg-name> \
    --location <location> \
    --sku Standard_LRS

# Create storage account with specific options
az storage account create \
    --name <storage-account-name> \
    --resource-group <rg-name> \
    --location <location> \
    --sku Standard_GRS \
    --kind StorageV2 \
    --access-tier Hot

# Create storage account with blob public access disabled
az storage account create \
    --name <storage-account-name> \
    --resource-group <rg-name> \
    --location <location> \
    --sku Standard_LRS \
    --allow-blob-public-access false
```

### Storage Account Operations
```bash
# Show storage account details
az storage account show \
    --name <storage-account-name> \
    --resource-group <rg-name>

# Update storage account access tier
az storage account update \
    --name <storage-account-name> \
    --resource-group <rg-name> \
    --access-tier Cool

# Get storage account keys
az storage account keys list \
    --account-name <storage-account-name> \
    --resource-group <rg-name>

# Regenerate storage key
az storage account keys renew \
    --account-name <storage-account-name> \
    --resource-group <rg-name> \
    --key key1

# Get connection string
az storage account show-connection-string \
    --name <storage-account-name> \
    --resource-group <rg-name>

# Delete storage account
az storage account delete \
    --name <storage-account-name> \
    --resource-group <rg-name>
```

## Container (Blob Container) Management

### Create and Manage Containers
```bash
# Create a container
az storage container create \
    --name <container-name> \
    --account-name <storage-account-name>

# Create container with public access
az storage container create \
    --name <container-name> \
    --account-name <storage-account-name> \
    --public-access blob

# List containers
az storage container list \
    --account-name <storage-account-name>

# Show container properties
az storage container show \
    --name <container-name> \
    --account-name <storage-account-name>

# Set container public access level
az storage container set-permission \
    --name <container-name> \
    --account-name <storage-account-name> \
    --public-access container

# Delete container
az storage container delete \
    --name <container-name> \
    --account-name <storage-account-name>
```

## Blob Management

### Upload and Download Blobs
```bash
# Upload a blob
az storage blob upload \
    --account-name <storage-account-name> \
    --container-name <container-name> \
    --name <blob-name> \
    --file <local-file-path>

# Upload blob with access tier
az storage blob upload \
    --account-name <storage-account-name> \
    --container-name <container-name> \
    --name <blob-name> \
    --file <local-file-path> \
    --tier Cool

# Upload blob with metadata
az storage blob upload \
    --account-name <storage-account-name> \
    --container-name <container-name> \
    --name <blob-name> \
    --file <local-file-path> \
    --metadata key1=value1 key2=value2

# Download a blob
az storage blob download \
    --account-name <storage-account-name> \
    --container-name <container-name> \
    --name <blob-name> \
    --file <local-file-path>

# List blobs in container
az storage blob list \
    --account-name <storage-account-name> \
    --container-name <container-name>

# Delete blob
az storage blob delete \
    --account-name <storage-account-name> \
    --container-name <container-name> \
    --name <blob-name>
```

### Blob Properties and Metadata
```bash
# Show blob properties
az storage blob show \
    --account-name <storage-account-name> \
    --container-name <container-name> \
    --name <blob-name>

# Set blob tier (change access tier)
az storage blob set-tier \
    --account-name <storage-account-name> \
    --container-name <container-name> \
    --name <blob-name> \
    --tier Archive

# Update blob metadata
az storage blob metadata update \
    --account-name <storage-account-name> \
    --container-name <container-name> \
    --name <blob-name> \
    --metadata version=2.0 author=admin

# Show blob metadata
az storage blob metadata show \
    --account-name <storage-account-name> \
    --container-name <container-name> \
    --name <blob-name>
```

### Copy Blobs
```bash
# Copy blob within same storage account
az storage blob copy start \
    --account-name <storage-account-name> \
    --destination-container <dest-container> \
    --destination-blob <dest-blob-name> \
    --source-container <source-container> \
    --source-blob <source-blob-name>

# Copy blob from URL
az storage blob copy start \
    --account-name <storage-account-name> \
    --destination-container <dest-container> \
    --destination-blob <dest-blob-name> \
    --source-uri <source-blob-url>
```

## Blob Lease Management

### Lease Operations
```bash
# Acquire blob lease
az storage blob lease acquire \
    --account-name <storage-account-name> \
    --container-name <container-name> \
    --blob-name <blob-name> \
    --lease-duration 60

# Break blob lease
az storage blob lease break \
    --account-name <storage-account-name> \
    --container-name <container-name> \
    --blob-name <blob-name>

# Release blob lease
az storage blob lease release \
    --account-name <storage-account-name> \
    --container-name <container-name> \
    --blob-name <blob-name> \
    --lease-id <lease-id>
```

## Lifecycle Management

### Configure Lifecycle Policy
```bash
# Set blob lifecycle management policy
az storage account management-policy create \
    --account-name <storage-account-name> \
    --resource-group <rg-name> \
    --policy @policy.json
```

Example policy.json for lifecycle:
```json
{
  "rules": [
    {
      "enabled": true,
      "name": "move-to-cool",
      "type": "Lifecycle",
      "definition": {
        "actions": {
          "baseBlob": {
            "tierToCool": {
              "daysAfterModificationGreaterThan": 30
            },
            "tierToArchive": {
              "daysAfterModificationGreaterThan": 90
            },
            "delete": {
              "daysAfterModificationGreaterThan": 365
            }
          }
        },
        "filters": {
          "blobTypes": ["blockBlob"],
          "prefixMatch": ["documents/"]
        }
      }
    }
  ]
}
```

## Shared Access Signatures (SAS)

### Generate SAS Tokens
```bash
# Generate account SAS
az storage account generate-sas \
    --account-name <storage-account-name> \
    --services b \
    --resource-types sco \
    --permissions rwdlac \
    --expiry 2024-12-31T23:59:59Z

# Generate blob SAS
az storage blob generate-sas \
    --account-name <storage-account-name> \
    --container-name <container-name> \
    --name <blob-name> \
    --permissions r \
    --expiry 2024-12-31T23:59:59Z

# Generate container SAS
az storage container generate-sas \
    --account-name <storage-account-name> \
    --name <container-name> \
    --permissions rl \
    --expiry 2024-12-31T23:59:59Z
```

## RBAC and Security

### Role Assignments
```bash
# Assign Storage Blob Data Contributor role
az role assignment create \
    --assignee <user-or-service-principal> \
    --role "Storage Blob Data Contributor" \
    --scope /subscriptions/<subscription-id>/resourceGroups/<rg-name>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>

# Assign Storage Blob Data Reader role
az role assignment create \
    --assignee <user-or-service-principal> \
    --role "Storage Blob Data Reader" \
    --scope /subscriptions/<subscription-id>/resourceGroups/<rg-name>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>
```

## Common Exam Scenarios

### Scenario: Configure Hot/Cool/Archive Tiers
```bash
# Create storage account with hot tier
az storage account create \
    --name mystorageacct \
    --resource-group myRG \
    --sku Standard_LRS \
    --access-tier Hot

# Upload blob to cool tier
az storage blob upload \
    --account-name mystorageacct \
    --container-name documents \
    --name report.pdf \
    --file ./report.pdf \
    --tier Cool

# Change existing blob to archive
az storage blob set-tier \
    --account-name mystorageacct \
    --container-name documents \
    --name old-data.zip \
    --tier Archive
```

### Scenario: Enable Static Website Hosting
```bash
# Enable static website
az storage blob service-properties update \
    --account-name <storage-account-name> \
    --static-website \
    --index-document index.html \
    --404-document 404.html

# Upload website content
az storage blob upload-batch \
    --account-name <storage-account-name> \
    --destination '$web' \
    --source ./website-files/
```
