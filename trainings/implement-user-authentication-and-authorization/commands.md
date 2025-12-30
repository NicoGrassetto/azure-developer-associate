# Azure Authentication & Authorization - Essential CLI Commands

## Microsoft Entra ID (Azure AD)

### App Registration
```bash
# Create app registration
az ad app create \
    --display-name <app-name>

# Create with redirect URI
az ad app create \
    --display-name <app-name> \
    --web-redirect-uris https://localhost:3000/auth/callback

# Show app details
az ad app show \
    --id <app-id>

# List apps
az ad app list \
    --display-name <app-name>

# Update app
az ad app update \
    --id <app-id> \
    --sign-in-audience AzureADMultipleOrgs

# Delete app
az ad app delete \
    --id <app-id>
```

### Service Principal
```bash
# Create service principal
az ad sp create-for-rbac \
    --name <sp-name>

# Create with specific role and scope
az ad sp create-for-rbac \
    --name <sp-name> \
    --role Contributor \
    --scopes /subscriptions/<subscription-id>/resourceGroups/<rg-name>

# Create with certificate
az ad sp create-for-rbac \
    --name <sp-name> \
    --cert @cert.pem \
    --create-cert

# Show service principal
az ad sp show \
    --id <app-id>

# List service principals
az ad sp list \
    --display-name <sp-name>

# Update service principal
az ad sp update \
    --id <app-id>

# Delete service principal
az ad sp delete \
    --id <app-id>

# Reset service principal credentials
az ad sp credential reset \
    --id <app-id>
```

### Application Credentials
```bash
# Add password credential
az ad app credential reset \
    --id <app-id>

# Add certificate credential
az ad app credential reset \
    --id <app-id> \
    --cert @cert.pem

# List credentials
az ad app credential list \
    --id <app-id>

# Delete credential
az ad app credential delete \
    --id <app-id> \
    --key-id <credential-key-id>
```

### API Permissions
```bash
# Add API permission (Microsoft Graph User.Read)
az ad app permission add \
    --id <app-id> \
    --api 00000003-0000-0000-c000-000000000000 \
    --api-permissions e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope

# Grant admin consent
az ad app permission admin-consent \
    --id <app-id>

# List API permissions
az ad app permission list \
    --id <app-id>

# Remove API permission
az ad app permission delete \
    --id <app-id> \
    --api <api-id>
```

## Azure Role-Based Access Control (RBAC)

### Role Assignments
```bash
# Assign role to user at subscription level
az role assignment create \
    --assignee user@example.com \
    --role Contributor \
    --scope /subscriptions/<subscription-id>

# Assign role to service principal
az role assignment create \
    --assignee <app-id> \
    --role "Storage Blob Data Contributor" \
    --scope /subscriptions/<subscription-id>/resourceGroups/<rg-name>

# Assign role to group
az role assignment create \
    --assignee-object-id <group-object-id> \
    --assignee-principal-type Group \
    --role Reader \
    --scope /subscriptions/<subscription-id>/resourceGroups/<rg-name>

# Assign role at resource level
az role assignment create \
    --assignee <user-or-sp> \
    --role Contributor \
    --scope /subscriptions/<subscription-id>/resourceGroups/<rg-name>/providers/Microsoft.Storage/storageAccounts/<storage-name>

# List role assignments
az role assignment list \
    --assignee user@example.com

# List role assignments for resource
az role assignment list \
    --scope /subscriptions/<subscription-id>/resourceGroups/<rg-name>

# Delete role assignment
az role assignment delete \
    --assignee user@example.com \
    --role Contributor \
    --scope /subscriptions/<subscription-id>/resourceGroups/<rg-name>
```

### Role Definitions
```bash
# List role definitions
az role definition list

# Show specific role
az role definition list \
    --name Contributor

# List custom roles
az role definition list \
    --custom-role-only true

# Create custom role
az role definition create \
    --role-definition @role-definition.json

# Update custom role
az role definition update \
    --role-definition @role-definition.json

# Delete custom role
az role definition delete \
    --name <custom-role-name>
```

Example custom role definition (role-definition.json):
```json
{
  "Name": "Storage Account Contributor",
  "Description": "Can manage storage accounts",
  "Actions": [
    "Microsoft.Storage/storageAccounts/*"
  ],
  "NotActions": [
    "Microsoft.Storage/storageAccounts/delete"
  ],
  "AssignableScopes": [
    "/subscriptions/<subscription-id>"
  ]
}
```

## Shared Access Signatures (SAS)

### Storage Account SAS
```bash
# Generate account SAS token
az storage account generate-sas \
    --account-name <storage-account> \
    --services bfqt \
    --resource-types sco \
    --permissions rwdlacup \
    --expiry 2024-12-31T23:59:59Z \
    --https-only

# Generate SAS with specific services
az storage account generate-sas \
    --account-name <storage-account> \
    --services b \
    --resource-types co \
    --permissions rl \
    --expiry 2024-12-31T23:59:59Z
```

### Blob SAS
```bash
# Generate blob SAS token
az storage blob generate-sas \
    --account-name <storage-account> \
    --container-name <container-name> \
    --name <blob-name> \
    --permissions r \
    --expiry 2024-12-31T23:59:59Z \
    --https-only

# Generate SAS with IP restriction
az storage blob generate-sas \
    --account-name <storage-account> \
    --container-name <container-name> \
    --name <blob-name> \
    --permissions r \
    --expiry 2024-12-31T23:59:59Z \
    --ip "168.1.5.60-168.1.5.70"
```

### Container SAS
```bash
# Generate container SAS token
az storage container generate-sas \
    --account-name <storage-account> \
    --name <container-name> \
    --permissions rl \
    --expiry 2024-12-31T23:59:59Z

# Generate SAS for full container access
az storage container generate-sas \
    --account-name <storage-account> \
    --name <container-name> \
    --permissions rwdl \
    --expiry 2024-12-31T23:59:59Z \
    --https-only
```

### Stored Access Policy
```bash
# Create stored access policy for container
az storage container policy create \
    --account-name <storage-account> \
    --container-name <container-name> \
    --name <policy-name> \
    --permissions rl \
    --expiry 2024-12-31T23:59:59Z

# List stored access policies
az storage container policy list \
    --account-name <storage-account> \
    --container-name <container-name>

# Update stored access policy
az storage container policy update \
    --account-name <storage-account> \
    --container-name <container-name> \
    --name <policy-name> \
    --permissions rwdl

# Delete stored access policy
az storage container policy delete \
    --account-name <storage-account> \
    --container-name <container-name> \
    --name <policy-name>

# Generate SAS using stored policy
az storage blob generate-sas \
    --account-name <storage-account> \
    --container-name <container-name> \
    --name <blob-name> \
    --policy-name <policy-name>
```

## Microsoft Graph

### Graph API Access (via CLI)
```bash
# Note: Graph API is typically accessed via REST or SDK, but you can use az rest

# Get current user profile
az rest \
    --method GET \
    --url https://graph.microsoft.com/v1.0/me

# List users
az rest \
    --method GET \
    --url https://graph.microsoft.com/v1.0/users

# Get user by ID
az rest \
    --method GET \
    --url https://graph.microsoft.com/v1.0/users/<user-id>

# List groups
az rest \
    --method GET \
    --url https://graph.microsoft.com/v1.0/groups
```

## Authentication with Azure Services

### Configure Azure AD Authentication for App Service
```bash
# Enable App Service authentication (Easy Auth)
az webapp auth update \
    --name <app-name> \
    --resource-group <rg-name> \
    --enabled true \
    --action LoginWithAzureActiveDirectory

# Configure Azure AD provider
az webapp auth microsoft update \
    --name <app-name> \
    --resource-group <rg-name> \
    --client-id <app-id> \
    --client-secret <client-secret> \
    --issuer https://sts.windows.net/<tenant-id>/

# Show auth settings
az webapp auth show \
    --name <app-name> \
    --resource-group <rg-name>
```

### Configure OAuth 2.0 for API Management
```bash
# Create OAuth 2.0 authorization server in APIM
az apim api authorization-server create \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --authorization-server-id <server-id> \
    --display-name "Azure AD OAuth" \
    --client-registration-endpoint https://login.microsoftonline.com/<tenant-id>/oauth2/v2.0/authorize \
    --authorization-endpoint https://login.microsoftonline.com/<tenant-id>/oauth2/v2.0/authorize \
    --token-endpoint https://login.microsoftonline.com/<tenant-id>/oauth2/v2.0/token \
    --client-id <app-id> \
    --client-secret <client-secret>
```

## Common Exam Scenarios

### Scenario: Service Principal with Key Vault Access
```bash
# 1. Create service principal
SP_OUTPUT=$(az ad sp create-for-rbac --name myapp-sp)
SP_APP_ID=$(echo $SP_OUTPUT | jq -r '.appId')
SP_PASSWORD=$(echo $SP_OUTPUT | jq -r '.password')

# 2. Create Key Vault
az keyvault create \
    --name mykeyvault \
    --resource-group myRG

# 3. Grant Key Vault access
az keyvault set-policy \
    --name mykeyvault \
    --spn $SP_APP_ID \
    --secret-permissions get list

# 4. Use credentials in application
echo "AZURE_CLIENT_ID=$SP_APP_ID"
echo "AZURE_CLIENT_SECRET=$SP_PASSWORD"
echo "AZURE_TENANT_ID=<tenant-id>"
```

### Scenario: Managed Identity with RBAC
```bash
# 1. Enable managed identity on web app
az webapp identity assign \
    --name myapp \
    --resource-group myRG

# 2. Get principal ID
PRINCIPAL_ID=$(az webapp identity show \
    --name myapp \
    --resource-group myRG \
    --query principalId -o tsv)

# 3. Assign Storage Blob Data Contributor role
az role assignment create \
    --assignee $PRINCIPAL_ID \
    --role "Storage Blob Data Contributor" \
    --scope /subscriptions/<sub-id>/resourceGroups/myRG/providers/Microsoft.Storage/storageAccounts/mystorageacct

# 4. Assign Key Vault Secrets User role
az role assignment create \
    --assignee $PRINCIPAL_ID \
    --role "Key Vault Secrets User" \
    --scope /subscriptions/<sub-id>/resourceGroups/myRG/providers/Microsoft.KeyVault/vaults/mykeyvault
```

### Scenario: Generate SAS Token for Blob Access
```bash
# Get storage account key
STORAGE_KEY=$(az storage account keys list \
    --account-name mystorageacct \
    --resource-group myRG \
    --query [0].value -o tsv)

# Generate blob SAS (read-only, 1 hour)
EXPIRY=$(date -u -d "1 hour" '+%Y-%m-%dT%H:%MZ')

az storage blob generate-sas \
    --account-name mystorageacct \
    --account-key $STORAGE_KEY \
    --container-name documents \
    --name report.pdf \
    --permissions r \
    --expiry $EXPIRY \
    --https-only
```

### Scenario: App Registration with API Permissions
```bash
# 1. Create app registration
APP_ID=$(az ad app create \
    --display-name myapp \
    --query appId -o tsv)

# 2. Create service principal
az ad sp create --id $APP_ID

# 3. Add Microsoft Graph User.Read permission
az ad app permission add \
    --id $APP_ID \
    --api 00000003-0000-0000-c000-000000000000 \
    --api-permissions e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope

# 4. Grant admin consent
az ad app permission admin-consent --id $APP_ID

# 5. Create client secret
az ad app credential reset --id $APP_ID
```
