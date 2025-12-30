# Azure Container Solutions - Essential CLI Commands

## Azure Container Registry (ACR)

### Create and Manage ACR
```bash
# Create container registry
az acr create \
    --name <registry-name> \
    --resource-group <rg-name> \
    --sku Basic

# Create ACR with Premium SKU (supports geo-replication)
az acr create \
    --name <registry-name> \
    --resource-group <rg-name> \
    --sku Premium \
    --location <location>

# Show registry details
az acr show \
    --name <registry-name> \
    --resource-group <rg-name>

# List registries
az acr list \
    --resource-group <rg-name>

# Update ACR SKU
az acr update \
    --name <registry-name> \
    --sku Standard

# Delete registry
az acr delete \
    --name <registry-name> \
    --resource-group <rg-name>
```

### ACR Authentication
```bash
# Enable admin user
az acr update \
    --name <registry-name> \
    --admin-enabled true

# Get admin credentials
az acr credential show \
    --name <registry-name>

# Login to ACR
az acr login --name <registry-name>

# Login with service principal
az acr login \
    --name <registry-name> \
    --username <service-principal-id> \
    --password <service-principal-password>
```

### ACR Image Management
```bash
# List repositories
az acr repository list \
    --name <registry-name>

# List tags for repository
az acr repository show-tags \
    --name <registry-name> \
    --repository <repository-name>

# Show repository details
az acr repository show \
    --name <registry-name> \
    --repository <repository-name>

# Delete image tag
az acr repository delete \
    --name <registry-name> \
    --repository <repository-name>:<tag> \
    --yes

# Untag image (keep manifest)
az acr repository untag \
    --name <registry-name> \
    --image <repository-name>:<tag>
```

### Build and Push Images
```bash
# Build image in ACR (ACR Tasks)
az acr build \
    --registry <registry-name> \
    --image <image-name>:<tag> \
    --file Dockerfile \
    .

# Quick build and push
az acr build \
    --registry <registry-name> \
    --image myapp:v1 \
    .

# Import image from Docker Hub
az acr import \
    --name <registry-name> \
    --source docker.io/library/nginx:latest \
    --image nginx:latest

# Tag local image and push
docker tag myimage:latest <registry-name>.azurecr.io/myimage:latest
docker push <registry-name>.azurecr.io/myimage:latest
```

### ACR Tasks
```bash
# Create ACR task for automated builds
az acr task create \
    --name buildtask \
    --registry <registry-name> \
    --context https://github.com/user/repo.git \
    --file Dockerfile \
    --image myapp:{{.Run.ID}} \
    --git-access-token <github-token>

# Run ACR task manually
az acr task run \
    --name buildtask \
    --registry <registry-name>

# List ACR tasks
az acr task list \
    --registry <registry-name>

# Show task details
az acr task show \
    --name buildtask \
    --registry <registry-name>
```

### ACR Webhooks
```bash
# Create webhook
az acr webhook create \
    --name <webhook-name> \
    --registry <registry-name> \
    --uri https://example.com/webhook \
    --actions push delete

# List webhooks
az acr webhook list \
    --registry <registry-name>

# Get webhook configuration
az acr webhook show \
    --name <webhook-name> \
    --registry <registry-name>

# Ping webhook
az acr webhook ping \
    --name <webhook-name> \
    --registry <registry-name>
```

## Azure Container Instances (ACI)

### Create Container Instances
```bash
# Create container instance (public image)
az container create \
    --name <container-name> \
    --resource-group <rg-name> \
    --image mcr.microsoft.com/azuredocs/aci-helloworld \
    --dns-name-label <dns-label> \
    --ports 80

# Create container with environment variables
az container create \
    --name <container-name> \
    --resource-group <rg-name> \
    --image <image-name> \
    --environment-variables KEY1=VALUE1 KEY2=VALUE2

# Create container with secure environment variables
az container create \
    --name <container-name> \
    --resource-group <rg-name> \
    --image <image-name> \
    --secure-environment-variables API_KEY=<secret-value>

# Create container from ACR
az container create \
    --name <container-name> \
    --resource-group <rg-name> \
    --image <registry-name>.azurecr.io/<image-name>:<tag> \
    --registry-login-server <registry-name>.azurecr.io \
    --registry-username <username> \
    --registry-password <password> \
    --dns-name-label <dns-label> \
    --ports 80

# Create container with managed identity
az container create \
    --name <container-name> \
    --resource-group <rg-name> \
    --image <image-name> \
    --assign-identity \
    --ports 80

# Create container with CPU and memory limits
az container create \
    --name <container-name> \
    --resource-group <rg-name> \
    --image <image-name> \
    --cpu 2 \
    --memory 4

# Create container with restart policy
az container create \
    --name <container-name> \
    --resource-group <rg-name> \
    --image <image-name> \
    --restart-policy OnFailure
```

### Manage Container Instances
```bash
# Show container details
az container show \
    --name <container-name> \
    --resource-group <rg-name>

# List containers
az container list \
    --resource-group <rg-name>

# Get container logs
az container logs \
    --name <container-name> \
    --resource-group <rg-name>

# Stream container logs
az container attach \
    --name <container-name> \
    --resource-group <rg-name>

# Execute command in container
az container exec \
    --name <container-name> \
    --resource-group <rg-name> \
    --exec-command "/bin/bash"

# Restart container
az container restart \
    --name <container-name> \
    --resource-group <rg-name>

# Stop container
az container stop \
    --name <container-name> \
    --resource-group <rg-name>

# Start container
az container start \
    --name <container-name> \
    --resource-group <rg-name>

# Delete container
az container delete \
    --name <container-name> \
    --resource-group <rg-name>
```

### Container Groups (Multi-container)
```bash
# Create container group with YAML
az container create \
    --resource-group <rg-name> \
    --file container-group.yaml

# Example YAML for multi-container group:
# apiVersion: 2019-12-01
# location: eastus
# name: mycontainergroup
# properties:
#   containers:
#   - name: container1
#     properties:
#       image: nginx
#       ports:
#       - port: 80
#   - name: container2
#     properties:
#       image: redis
#   osType: Linux
```

### Mount Azure File Share
```bash
# Create container with Azure Files volume
az container create \
    --name <container-name> \
    --resource-group <rg-name> \
    --image <image-name> \
    --azure-file-volume-account-name <storage-account> \
    --azure-file-volume-account-key <storage-key> \
    --azure-file-volume-share-name <share-name> \
    --azure-file-volume-mount-path /mnt/azurefile
```

## Azure Container Apps

### Create Container Apps Environment
```bash
# Create Container Apps environment
az containerapp env create \
    --name <environment-name> \
    --resource-group <rg-name> \
    --location <location>

# Create environment with Log Analytics workspace
az containerapp env create \
    --name <environment-name> \
    --resource-group <rg-name> \
    --location <location> \
    --logs-workspace-id <workspace-id> \
    --logs-workspace-key <workspace-key>

# List environments
az containerapp env list \
    --resource-group <rg-name>

# Show environment details
az containerapp env show \
    --name <environment-name> \
    --resource-group <rg-name>

# Delete environment
az containerapp env delete \
    --name <environment-name> \
    --resource-group <rg-name>
```

### Create and Manage Container Apps
```bash
# Create container app
az containerapp create \
    --name <app-name> \
    --resource-group <rg-name> \
    --environment <environment-name> \
    --image <image-name> \
    --target-port 80 \
    --ingress external

# Create container app with environment variables
az containerapp create \
    --name <app-name> \
    --resource-group <rg-name> \
    --environment <environment-name> \
    --image <image-name> \
    --env-vars KEY1=VALUE1 KEY2=secretref:secretname

# Create container app from ACR
az containerapp create \
    --name <app-name> \
    --resource-group <rg-name> \
    --environment <environment-name> \
    --image <registry-name>.azurecr.io/<image-name>:<tag> \
    --registry-server <registry-name>.azurecr.io \
    --registry-username <username> \
    --registry-password <password> \
    --target-port 80 \
    --ingress external

# Update container app
az containerapp update \
    --name <app-name> \
    --resource-group <rg-name> \
    --image <new-image>

# List container apps
az containerapp list \
    --resource-group <rg-name>

# Show container app details
az containerapp show \
    --name <app-name> \
    --resource-group <rg-name>

# Delete container app
az containerapp delete \
    --name <app-name> \
    --resource-group <rg-name>
```

### Container App Scaling
```bash
# Update scaling rules
az containerapp update \
    --name <app-name> \
    --resource-group <rg-name> \
    --min-replicas 1 \
    --max-replicas 10

# Set scale rule based on HTTP requests
az containerapp update \
    --name <app-name> \
    --resource-group <rg-name> \
    --scale-rule-name http-rule \
    --scale-rule-type http \
    --scale-rule-http-concurrency 50
```

### Container App Revisions
```bash
# List revisions
az containerapp revision list \
    --name <app-name> \
    --resource-group <rg-name>

# Show revision details
az containerapp revision show \
    --name <app-name> \
    --resource-group <rg-name> \
    --revision <revision-name>

# Activate revision
az containerapp revision activate \
    --name <app-name> \
    --resource-group <rg-name> \
    --revision <revision-name>

# Deactivate revision
az containerapp revision deactivate \
    --name <app-name> \
    --resource-group <rg-name> \
    --revision <revision-name>
```

## Common Exam Scenarios

### Scenario: Build and Deploy to ACI from ACR
```bash
# 1. Create ACR
az acr create --name myacr --resource-group myRG --sku Basic

# 2. Build image in ACR
az acr build --registry myacr --image myapp:v1 .

# 3. Get ACR credentials
ACR_USER=$(az acr credential show --name myacr --query username -o tsv)
ACR_PASS=$(az acr credential show --name myacr --query passwords[0].value -o tsv)

# 4. Deploy to ACI
az container create \
    --name mycontainer \
    --resource-group myRG \
    --image myacr.azurecr.io/myapp:v1 \
    --registry-login-server myacr.azurecr.io \
    --registry-username $ACR_USER \
    --registry-password $ACR_PASS \
    --dns-name-label myapp-demo \
    --ports 80
```

### Scenario: Container Apps with Auto-scaling
```bash
# Create environment
az containerapp env create \
    --name myenv \
    --resource-group myRG \
    --location eastus

# Create container app with scaling
az containerapp create \
    --name myapp \
    --resource-group myRG \
    --environment myenv \
    --image mcr.microsoft.com/azuredocs/containerapps-helloworld:latest \
    --target-port 80 \
    --ingress external \
    --min-replicas 1 \
    --max-replicas 5
```
