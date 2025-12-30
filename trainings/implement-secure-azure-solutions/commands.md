# Azure Security Solutions - Essential CLI Commands

## Azure Key Vault

### Create and Manage Key Vault
```bash
# Create key vault
az keyvault create \
    --name <vault-name> \
    --resource-group <rg-name> \
    --location <location>

# Create key vault with specific SKU
az keyvault create \
    --name <vault-name> \
    --resource-group <rg-name> \
    --location <location> \
    --sku premium

# Create key vault with RBAC authorization
az keyvault create \
    --name <vault-name> \
    --resource-group <rg-name> \
    --location <location> \
    --enable-rbac-authorization true

# Show key vault details
az keyvault show \
    --name <vault-name>

# List key vaults
az keyvault list \
    --resource-group <rg-name>

# Delete key vault (soft delete)
az keyvault delete \
    --name <vault-name>

# Purge deleted key vault (permanent)
az keyvault purge \
    --name <vault-name> \
    --location <location>

# List deleted key vaults
az keyvault list-deleted

# Recover deleted key vault
az keyvault recover \
    --name <vault-name> \
    --location <location>
```

### Key Vault Access Policies
```bash
# Set access policy for user
az keyvault set-policy \
    --name <vault-name> \
    --upn user@example.com \
    --secret-permissions get list set delete

# Set access policy for service principal
az keyvault set-policy \
    --name <vault-name> \
    --object-id <object-id> \
    --secret-permissions get list \
    --key-permissions get list \
    --certificate-permissions get list

# Set access policy for managed identity
az keyvault set-policy \
    --name <vault-name> \
    --object-id <managed-identity-object-id> \
    --secret-permissions get

# Delete access policy
az keyvault delete-policy \
    --name <vault-name> \
    --object-id <object-id>
```

### Secrets Management
```bash
# Create secret
az keyvault secret set \
    --vault-name <vault-name> \
    --name <secret-name> \
    --value <secret-value>

# Create secret with expiration
az keyvault secret set \
    --vault-name <vault-name> \
    --name <secret-name> \
    --value <secret-value> \
    --expires 2025-12-31T23:59:59Z

# Get secret value
az keyvault secret show \
    --vault-name <vault-name> \
    --name <secret-name>

# Get only secret value (not metadata)
az keyvault secret show \
    --vault-name <vault-name> \
    --name <secret-name> \
    --query value -o tsv

# List secrets
az keyvault secret list \
    --vault-name <vault-name>

# List secret versions
az keyvault secret list-versions \
    --vault-name <vault-name> \
    --name <secret-name>

# Update secret
az keyvault secret set \
    --vault-name <vault-name> \
    --name <secret-name> \
    --value <new-value>

# Delete secret (soft delete)
az keyvault secret delete \
    --vault-name <vault-name> \
    --name <secret-name>

# Purge deleted secret (permanent)
az keyvault secret purge \
    --vault-name <vault-name> \
    --name <secret-name>

# Recover deleted secret
az keyvault secret recover \
    --vault-name <vault-name> \
    --name <secret-name>

# Download secret to file
az keyvault secret download \
    --vault-name <vault-name> \
    --name <secret-name> \
    --file secret.txt
```

### Keys Management
```bash
# Create key
az keyvault key create \
    --vault-name <vault-name> \
    --name <key-name> \
    --kty RSA

# Create key with specific size
az keyvault key create \
    --vault-name <vault-name> \
    --name <key-name> \
    --kty RSA \
    --size 4096

# Create EC key
az keyvault key create \
    --vault-name <vault-name> \
    --name <key-name> \
    --kty EC

# Get key
az keyvault key show \
    --vault-name <vault-name> \
    --name <key-name>

# List keys
az keyvault key list \
    --vault-name <vault-name>

# Delete key
az keyvault key delete \
    --vault-name <vault-name> \
    --name <key-name>

# Backup key
az keyvault key backup \
    --vault-name <vault-name> \
    --name <key-name> \
    --file key-backup.blob

# Restore key
az keyvault key restore \
    --vault-name <vault-name> \
    --file key-backup.blob
```

### Certificates Management
```bash
# Create self-signed certificate
az keyvault certificate create \
    --vault-name <vault-name> \
    --name <cert-name> \
    --policy "$(az keyvault certificate get-default-policy)"

# Create certificate with custom policy
az keyvault certificate create \
    --vault-name <vault-name> \
    --name <cert-name> \
    --policy @policy.json

# Get certificate
az keyvault certificate show \
    --vault-name <vault-name> \
    --name <cert-name>

# List certificates
az keyvault certificate list \
    --vault-name <vault-name>

# Download certificate
az keyvault certificate download \
    --vault-name <vault-name> \
    --name <cert-name> \
    --file cert.pem

# Delete certificate
az keyvault certificate delete \
    --vault-name <vault-name> \
    --name <cert-name>

# Import certificate
az keyvault certificate import \
    --vault-name <vault-name> \
    --name <cert-name> \
    --file cert.pfx \
    --password <password>
```

## Managed Identities

### System-Assigned Managed Identity
```bash
# Enable system-assigned identity on VM
az vm identity assign \
    --name <vm-name> \
    --resource-group <rg-name>

# Enable on App Service
az webapp identity assign \
    --name <app-name> \
    --resource-group <rg-name>

# Enable on Function App
az functionapp identity assign \
    --name <function-app-name> \
    --resource-group <rg-name>

# Get system-assigned identity details
az vm identity show \
    --name <vm-name> \
    --resource-group <rg-name>

# Remove system-assigned identity
az vm identity remove \
    --name <vm-name> \
    --resource-group <rg-name>
```

### User-Assigned Managed Identity
```bash
# Create user-assigned identity
az identity create \
    --name <identity-name> \
    --resource-group <rg-name>

# Show identity details
az identity show \
    --name <identity-name> \
    --resource-group <rg-name>

# List identities
az identity list \
    --resource-group <rg-name>

# Assign to VM
az vm identity assign \
    --name <vm-name> \
    --resource-group <rg-name> \
    --identities <identity-resource-id>

# Assign to App Service
az webapp identity assign \
    --name <app-name> \
    --resource-group <rg-name> \
    --identities <identity-resource-id>

# Delete identity
az identity delete \
    --name <identity-name> \
    --resource-group <rg-name>
```

### Role Assignments for Managed Identity
```bash
# Get managed identity principal ID
PRINCIPAL_ID=$(az identity show \
    --name <identity-name> \
    --resource-group <rg-name> \
    --query principalId -o tsv)

# Assign role to managed identity
az role assignment create \
    --assignee $PRINCIPAL_ID \
    --role "Storage Blob Data Contributor" \
    --scope <resource-id>

# Assign Key Vault access
az role assignment create \
    --assignee $PRINCIPAL_ID \
    --role "Key Vault Secrets User" \
    --scope /subscriptions/<sub-id>/resourceGroups/<rg>/providers/Microsoft.KeyVault/vaults/<vault-name>
```

## Azure App Configuration

### Create and Manage App Configuration
```bash
# Create App Configuration store
az appconfig create \
    --name <config-store-name> \
    --resource-group <rg-name> \
    --location <location> \
    --sku Free

# Create with Standard SKU
az appconfig create \
    --name <config-store-name> \
    --resource-group <rg-name> \
    --location <location> \
    --sku Standard

# Show details
az appconfig show \
    --name <config-store-name> \
    --resource-group <rg-name>

# List App Configuration stores
az appconfig list \
    --resource-group <rg-name>

# Delete App Configuration store
az appconfig delete \
    --name <config-store-name> \
    --resource-group <rg-name>
```

### Key-Value Management
```bash
# Set key-value
az appconfig kv set \
    --name <config-store-name> \
    --key MyKey \
    --value MyValue

# Set key-value with label
az appconfig kv set \
    --name <config-store-name> \
    --key MyKey \
    --value ProductionValue \
    --label Production

# Set key-value with content type
az appconfig kv set \
    --name <config-store-name> \
    --key ConnectionStrings:Database \
    --value "Server=...;" \
    --content-type "application/json"

# Get key-value
az appconfig kv show \
    --name <config-store-name> \
    --key MyKey

# Get key-value with label
az appconfig kv show \
    --name <config-store-name> \
    --key MyKey \
    --label Production

# List key-values
az appconfig kv list \
    --name <config-store-name>

# List with filter
az appconfig kv list \
    --name <config-store-name> \
    --key "ConnectionStrings:*"

# Delete key-value
az appconfig kv delete \
    --name <config-store-name> \
    --key MyKey

# Import from file
az appconfig kv import \
    --name <config-store-name> \
    --source file \
    --path config.json \
    --format json

# Export to file
az appconfig kv export \
    --name <config-store-name> \
    --destination file \
    --path export.json \
    --format json
```

### Feature Flags
```bash
# Set feature flag
az appconfig feature set \
    --name <config-store-name> \
    --feature MyFeature \
    --label Production

# Enable feature flag
az appconfig feature enable \
    --name <config-store-name> \
    --feature MyFeature

# Disable feature flag
az appconfig feature disable \
    --name <config-store-name> \
    --feature MyFeature

# List feature flags
az appconfig feature list \
    --name <config-store-name>

# Show feature flag
az appconfig feature show \
    --name <config-store-name> \
    --feature MyFeature

# Delete feature flag
az appconfig feature delete \
    --name <config-store-name> \
    --feature MyFeature
```

## Common Exam Scenarios

### Scenario: Web App with Key Vault Integration
```bash
# 1. Create Key Vault
az keyvault create \
    --name mykeyvault \
    --resource-group myRG \
    --location eastus

# 2. Add secret
az keyvault secret set \
    --vault-name mykeyvault \
    --name DatabasePassword \
    --value "SuperSecret123!"

# 3. Create web app with managed identity
az webapp create \
    --name myapp \
    --resource-group myRG \
    --plan myplan

az webapp identity assign \
    --name myapp \
    --resource-group myRG

# 4. Get principal ID
PRINCIPAL_ID=$(az webapp identity show \
    --name myapp \
    --resource-group myRG \
    --query principalId -o tsv)

# 5. Grant Key Vault access
az keyvault set-policy \
    --name mykeyvault \
    --object-id $PRINCIPAL_ID \
    --secret-permissions get

# 6. Reference in app settings
az webapp config appsettings set \
    --name myapp \
    --resource-group myRG \
    --settings DatabasePassword="@Microsoft.KeyVault(SecretUri=https://mykeyvault.vault.azure.net/secrets/DatabasePassword/)"
```

### Scenario: App Configuration with Managed Identity
```bash
# Create App Configuration
az appconfig create \
    --name myappconfig \
    --resource-group myRG \
    --sku Standard

# Enable managed identity on Function App
az functionapp identity assign \
    --name myfunc \
    --resource-group myRG

# Get principal ID
PRINCIPAL_ID=$(az functionapp identity show \
    --name myfunc \
    --resource-group myRG \
    --query principalId -o tsv)

# Assign App Configuration Data Reader role
az role assignment create \
    --assignee $PRINCIPAL_ID \
    --role "App Configuration Data Reader" \
    --scope /subscriptions/<sub-id>/resourceGroups/myRG/providers/Microsoft.AppConfiguration/configurationStores/myappconfig
```
