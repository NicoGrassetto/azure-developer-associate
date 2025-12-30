# Azure API Management - Essential CLI Commands

## API Management Service

### Create and Manage APIM Instance
```bash
# Create API Management instance (Basic SKU)
az apim create \
    --name <apim-name> \
    --resource-group <rg-name> \
    --location <location> \
    --publisher-email admin@example.com \
    --publisher-name "My Company" \
    --sku-name Basic

# Create APIM with Consumption SKU
az apim create \
    --name <apim-name> \
    --resource-group <rg-name> \
    --location <location> \
    --publisher-email admin@example.com \
    --publisher-name "My Company" \
    --sku-name Consumption

# Show APIM details
az apim show \
    --name <apim-name> \
    --resource-group <rg-name>

# Update APIM instance
az apim update \
    --name <apim-name> \
    --resource-group <rg-name> \
    --sku-name Standard

# Delete APIM instance
az apim delete \
    --name <apim-name> \
    --resource-group <rg-name>
```

## API Management

### Create and Configure APIs
```bash
# Create API from OpenAPI specification
az apim api create \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --api-id <api-id> \
    --path <api-path> \
    --display-name "My API" \
    --protocols https \
    --service-url https://backend.example.com

# Import API from OpenAPI/Swagger URL
az apim api import \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --path <api-path> \
    --specification-url https://example.com/swagger.json \
    --specification-format OpenApi

# List APIs
az apim api list \
    --resource-group <rg-name> \
    --service-name <apim-name>

# Show API details
az apim api show \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --api-id <api-id>

# Update API
az apim api update \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --api-id <api-id> \
    --description "Updated API description"

# Delete API
az apim api delete \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --api-id <api-id>
```

### API Operations
```bash
# Create API operation
az apim api operation create \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --api-id <api-id> \
    --operation-id get-users \
    --method GET \
    --url-template "/users" \
    --display-name "Get Users"

# List API operations
az apim api operation list \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --api-id <api-id>
```

## Products

### Product Management
```bash
# Create product
az apim product create \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --product-id <product-id> \
    --product-name "Starter" \
    --description "Starter tier product" \
    --subscription-required true \
    --approval-required false \
    --state published

# Add API to product
az apim product api add \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --product-id <product-id> \
    --api-id <api-id>

# List products
az apim product list \
    --resource-group <rg-name> \
    --service-name <apim-name>

# Delete product
az apim product delete \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --product-id <product-id>
```

## Subscriptions

### Subscription Management
```bash
# Create subscription
az apim subscription create \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --subscription-id <subscription-id> \
    --name "My Subscription" \
    --scope /products/<product-id>

# List subscriptions
az apim subscription list \
    --resource-group <rg-name> \
    --service-name <apim-name>

# Show subscription keys
az apim subscription show \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --subscription-id <subscription-id>

# Regenerate subscription key
az apim subscription regenerate-key \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --subscription-id <subscription-id> \
    --key-type primary

# Delete subscription
az apim subscription delete \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --subscription-id <subscription-id>
```

## Policies

### Policy Management
```bash
# Note: Policy management is typically done via Azure Portal or ARM templates
# Policy XML can be set at different scopes: Global, Product, API, Operation

# Show API policy
az apim api policy show \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --api-id <api-id>

# Set API policy from file
az apim api policy create \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --api-id <api-id> \
    --policy-file policy.xml

# Delete API policy
az apim api policy delete \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --api-id <api-id>
```

Example rate limit policy (policy.xml):
```xml
<policies>
    <inbound>
        <rate-limit calls="5" renewal-period="60" />
        <quota calls="100" renewal-period="86400" />
        <base />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
```

Example transformation policy:
```xml
<policies>
    <inbound>
        <set-header name="X-API-Key" exists-action="override">
            <value>@(context.Subscription.Key)</value>
        </set-header>
        <base />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <set-header name="X-Powered-By" exists-action="delete" />
        <base />
    </outbound>
</policies>
```

## Backends

### Backend Configuration
```bash
# Create backend
az apim backend create \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --backend-id <backend-id> \
    --url https://backend.example.com \
    --protocol http

# List backends
az apim backend list \
    --resource-group <rg-name> \
    --service-name <apim-name>

# Delete backend
az apim backend delete \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --backend-id <backend-id>
```

## Named Values (Properties)

### Named Values Management
```bash
# Create named value
az apim nv create \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --named-value-id <nv-id> \
    --display-name "BackendUrl" \
    --value "https://backend.example.com"

# Create secret named value
az apim nv create \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --named-value-id <nv-id> \
    --display-name "ApiKey" \
    --value "secret-key-value" \
    --secret true

# List named values
az apim nv list \
    --resource-group <rg-name> \
    --service-name <apim-name>

# Show named value
az apim nv show \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --named-value-id <nv-id>

# Update named value
az apim nv update \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --named-value-id <nv-id> \
    --value "new-value"

# Delete named value
az apim nv delete \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --named-value-id <nv-id>
```

## Users and Groups

### User Management
```bash
# Create user
az apim user create \
    --resource-group <rg-name> \
    --service-name <apim-name> \
    --user-id <user-id> \
    --email user@example.com \
    --first-name John \
    --last-name Doe

# List users
az apim user list \
    --resource-group <rg-name> \
    --service-name <apim-name>
```

## Common Exam Scenarios

### Scenario: Create APIM with Rate Limiting
```bash
# Create APIM instance
az apim create \
    --name myapim \
    --resource-group myRG \
    --location eastus \
    --publisher-email admin@example.com \
    --publisher-name "My Company" \
    --sku-name Consumption

# Create API
az apim api create \
    --resource-group myRG \
    --service-name myapim \
    --api-id my-api \
    --path /api \
    --display-name "My API" \
    --protocols https

# Apply rate limit policy (via portal or policy.xml)
```

### Scenario: Subscription-based API Access
```bash
# Create product with subscription requirement
az apim product create \
    --resource-group myRG \
    --service-name myapim \
    --product-id premium-tier \
    --product-name "Premium" \
    --subscription-required true \
    --approval-required true \
    --state published

# Add API to product
az apim product api add \
    --resource-group myRG \
    --service-name myapim \
    --product-id premium-tier \
    --api-id my-api

# Create subscription for user
az apim subscription create \
    --resource-group myRG \
    --service-name myapim \
    --subscription-id premium-subscription \
    --name "Premium Access" \
    --scope /products/premium-tier
```
