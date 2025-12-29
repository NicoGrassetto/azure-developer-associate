# Azure Container Solutions - Concepts Cheatsheet

## Overview
Azure provides multiple container services: Container Registry (ACR) for storing images, Container Instances (ACI) for simple deployments, and Container Apps for microservices.

## Azure Container Services Landscape

```mermaid
graph TB
    subgraph "Container Services"
        ACR[Azure Container Registry<br/>Private registry for images]
        ACI[Azure Container Instances<br/>Serverless containers]
        ACA[Azure Container Apps<br/>Microservices platform]
        AKS[Azure Kubernetes Service<br/>Orchestration at scale]
    end
    
    subgraph "Use Cases"
        Store[Store & Manage Images]
        Quick[Quick container deployment]
        Micro[Microservices & APIs]
        Complex[Complex orchestration]
    end
    
    ACR -.-> Store
    ACI -.-> Quick
    ACA -.-> Micro
    AKS -.-> Complex
    
    ACR -->|Pull Images| ACI & ACA & AKS
```

## Azure Container Registry Architecture

```mermaid
graph TB
    subgraph "Image Sources"
        Dev[Developer]
        CI[CI/CD Pipeline]
        Local[Local Build]
    end
    
    subgraph "Azure Container Registry"
        Registry[Container Registry]
        
        subgraph "Service Tiers"
            Basic[Basic<br/>Entry-level]
            Standard[Standard<br/>Production]
            Premium[Premium<br/>Geo-replication]
        end
        
        subgraph "Features"
            Tasks[ACR Tasks<br/>Cloud builds]
            Webhook[Webhooks<br/>Notifications]
            GeoRep[Geo-replication<br/>Multi-region]
        end
    end
    
    subgraph "Deployment Targets"
        ACI[Container Instances]
        ACA[Container Apps]
        AKS[AKS]
        AppService[App Service]
    end
    
    Dev & CI & Local -->|Push| Registry
    Registry --> Basic & Standard & Premium
    Registry --> Tasks & Webhook & GeoRep
    Registry -->|Pull| ACI & ACA & AKS & AppService
```

## ACR Tasks Workflow

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant Repo as Git Repository
    participant ACR as ACR Tasks
    participant Registry as Registry
    participant Deploy as Deployment
    
    Dev->>Repo: Push code
    Repo->>ACR: Trigger webhook
    ACR->>ACR: Build image
    ACR->>ACR: Run tests
    ACR->>Registry: Push image
    Registry->>Deploy: Deploy to target
    Deploy-->>Dev: Deployment complete
```

## ACR Task Triggers

```mermaid
graph LR
    subgraph "Trigger Types"
        Source[Source Code Commit<br/>Git push/PR]
        Base[Base Image Update<br/>Parent image changed]
        Schedule[Schedule<br/>Cron-based]
        Manual[Manual<br/>On-demand]
    end
    
    subgraph "ACR Task"
        Build[Build Image]
        Test[Run Tests]
        Push[Push to Registry]
    end
    
    Source & Base & Schedule & Manual --> Build
    Build --> Test
    Test --> Push
```

## Azure Container Instances Architecture

```mermaid
graph TB
    subgraph "Container Instance"
        CG[Container Group]
        
        subgraph "Containers"
            C1[Container 1<br/>App]
            C2[Container 2<br/>Sidecar]
        end
        
        subgraph "Resources"
            CPU[Shared CPU]
            Memory[Shared Memory]
            Storage[Volume Storage]
            Network[Network Interface]
        end
    end
    
    subgraph "External Services"
        Files[Azure Files]
        EmptyDir[Empty Directory]
        Secret[Secret Volume]
    end
    
    CG --> C1 & C2
    C1 & C2 --> CPU & Memory & Storage & Network
    Storage --> Files & EmptyDir & Secret
```

## Container Groups

```mermaid
graph TB
    subgraph "Container Group (Pod)"
        direction LR
        
        subgraph "Shared Resources"
            IP[IP Address]
            DNS[DNS Label]
            Ports[Ports]
        end
        
        subgraph "Container 1"
            App1[Application]
            Port1[Port: 80]
        end
        
        subgraph "Container 2"
            App2[Sidecar/Helper]
            Port2[Port: 8080]
        end
        
        subgraph "Volumes"
            Vol1[Azure Files]
            Vol2[Secret]
        end
    end
    
    IP & DNS --> Port1 & Port2
    App1 --> Vol1
    App2 --> Vol2
```

## Azure Container Apps Architecture

```mermaid
graph TB
    subgraph "Container Apps Environment"
        LB[Load Balancer]
        
        subgraph "Container Apps"
            App1[App 1<br/>API Service]
            App2[App 2<br/>Web Frontend]
            App3[App 3<br/>Background Worker]
        end
        
        subgraph "Built-in Features"
            KEDA[KEDA Autoscaling]
            Dapr[Dapr Integration]
            Ingress[Ingress Controller]
            RevMgmt[Revision Management]
        end
        
        subgraph "Managed Infrastructure"
            VNet[Virtual Network]
            LogAnalytics[Log Analytics]
        end
    end
    
    LB --> App1 & App2
    App1 & App2 & App3 --> KEDA & Dapr & Ingress & RevMgmt
    KEDA & Dapr & Ingress & RevMgmt --> VNet & LogAnalytics
```

## Container Apps Scaling

```mermaid
graph LR
    subgraph "Scale Triggers"
        HTTP[HTTP Traffic]
        Queue[Queue Length]
        CPU[CPU Usage]
        Memory[Memory Usage]
        Custom[Custom Metrics]
        Cron[Schedule]
    end
    
    subgraph "KEDA Scaler"
        Rules[Scaling Rules<br/>Min: 0, Max: 30]
        Decision[Scale Decision]
    end
    
    subgraph "Replicas"
        R0[0 Replicas<br/>Scale to zero]
        R1[1-5 Replicas]
        R2[6-30 Replicas]
    end
    
    HTTP & Queue & CPU & Memory & Custom & Cron --> Rules
    Rules --> Decision
    Decision -->|No load| R0
    Decision -->|Low load| R1
    Decision -->|High load| R2
```

## Container Apps Revisions

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant RevA as Revision A<br/>(v1.0)
    participant RevB as Revision B<br/>(v2.0)
    participant Users as Users
    
    Users->>RevA: 100% traffic
    Dev->>RevB: Deploy new version
    Note over RevB: Test internally
    Dev->>RevA: Split traffic 70%
    Dev->>RevB: Split traffic 30%
    Users->>RevA: 70% traffic
    Users->>RevB: 30% traffic
    Note over RevB: Monitor metrics
    Dev->>RevB: Shift to 100%
    Users->>RevB: 100% traffic
    Note over RevA: Keep for rollback
```

## Container Deployment Workflow

```mermaid
graph LR
    subgraph "Development"
        Code[Source Code]
        Dockerfile[Dockerfile]
        Build[Build Image]
    end
    
    subgraph "Registry"
        ACR[Azure Container<br/>Registry]
    end
    
    subgraph "Deployment Options"
        ACI[Container Instances<br/>Simple apps]
        ACA[Container Apps<br/>Microservices]
        AppService[App Service<br/>Web apps]
        AKS[AKS<br/>Complex apps]
    end
    
    Code & Dockerfile --> Build
    Build -->|Push| ACR
    ACR -->|Pull & Deploy| ACI & ACA & AppService & AKS
```

## Multi-Container Deployment

```mermaid
graph TB
    subgraph "Docker Compose / YAML"
        Definition[Container Definition]
    end
    
    subgraph "Container Group"
        direction LR
        Web[Web Container<br/>nginx:latest]
        API[API Container<br/>api:v1.0]
        Cache[Redis Container<br/>redis:alpine]
        
        SharedVol[Shared Volume]
    end
    
    subgraph "Networking"
        IP[Single IP]
        Port80[Port 80<br/>Web]
        Port443[Port 443<br/>Web SSL]
        Port3000[Port 3000<br/>API]
    end
    
    Definition --> Web & API & Cache
    Web & API --> SharedVol
    Web --> Port80 & Port443
    API --> Port3000
    Port80 & Port443 & Port3000 --> IP
```

## Container Apps with Dapr

```mermaid
graph TB
    subgraph "Container App"
        App[Application Container]
        Dapr[Dapr Sidecar]
    end
    
    subgraph "Dapr Building Blocks"
        ServiceInv[Service Invocation]
        StateMgmt[State Management]
        PubSub[Pub/Sub]
        Bindings[Bindings]
        Secrets[Secrets]
    end
    
    subgraph "External Services"
        StateStore[State Store<br/>Cosmos DB/Redis]
        MessageBroker[Message Broker<br/>Service Bus]
        SecretStore[Secret Store<br/>Key Vault]
    end
    
    App --> Dapr
    Dapr --> ServiceInv & StateMgmt & PubSub & Bindings & Secrets
    StateMgmt --> StateStore
    PubSub --> MessageBroker
    Secrets --> SecretStore
```

## Container Networking

```mermaid
graph TB
    subgraph "Networking Options"
        Public[Public IP<br/>Internet accessible]
        Private[Private IP<br/>VNet integration]
        Internal[Internal<br/>Environment only]
    end
    
    subgraph "Container Apps Environment"
        subgraph "External Environment"
            ExtLB[External Load Balancer]
            ExtApps[Apps with external ingress]
        end
        
        subgraph "Internal Environment"
            IntLB[Internal Load Balancer]
            IntApps[Apps with internal ingress]
        end
        
        VNet[Virtual Network<br/>Subnet]
    end
    
    Public --> ExtLB
    ExtLB --> ExtApps
    Private --> IntLB
    IntLB --> IntApps
    Internal --> IntApps
    ExtApps & IntApps --> VNet
```

## Container Security

```mermaid
graph TB
    subgraph "Security Layers"
        direction TB
        
        Registry[Registry Security<br/>Private ACR, RBAC]
        Image[Image Security<br/>Scan for vulnerabilities]
        Runtime[Runtime Security<br/>Managed identities]
        Network[Network Security<br/>VNet integration]
        Secrets[Secrets Management<br/>Key Vault, Environment vars]
    end
    
    subgraph "Best Practices"
        MinImage[Minimal base images]
        NoRoot[Non-root user]
        ReadOnly[Read-only filesystem]
        ScanImage[Regular scanning]
        UpdateBase[Update base images]
    end
    
    Registry --> Image --> Runtime --> Network --> Secrets
    Registry & Image & Runtime & Network & Secrets --> MinImage & NoRoot & ReadOnly & ScanImage & UpdateBase
```

## Monitoring & Logging

```mermaid
graph TB
    subgraph "Container Apps"
        App1[App 1]
        App2[App 2]
        System[System Logs]
    end
    
    subgraph "Log Analytics Workspace"
        Logs[Container Logs]
        Metrics[Metrics]
        Traces[Distributed Traces]
    end
    
    subgraph "Monitoring Tools"
        Portal[Azure Portal]
        AppInsights[Application Insights]
        Alerts[Azure Alerts]
        Dashboards[Custom Dashboards]
    end
    
    App1 & App2 & System --> Logs & Metrics & Traces
    Logs & Metrics & Traces --> Portal & AppInsights & Alerts & Dashboards
```

## Key Concepts Summary

### Azure Container Registry (ACR)
- **Purpose**: Private Docker registry
- **Tiers**: Basic, Standard, Premium
- **Features**: Tasks, Webhooks, Geo-replication
- **Use Cases**: Store images, build in cloud, automate workflows

### Azure Container Instances (ACI)
- **Purpose**: Serverless container deployment
- **Features**: Fast startup, per-second billing, container groups
- **Networking**: Public IP, VNet integration, DNS labels
- **Use Cases**: Batch jobs, task automation, CI/CD build agents

### Azure Container Apps
- **Purpose**: Microservices platform
- **Features**: KEDA scaling, Dapr, revisions, ingress
- **Scaling**: Scale to zero, event-driven, HTTP autoscaling
- **Use Cases**: Microservices, APIs, background workers, event processing

### Container Groups (ACI)
- **Definition**: Collection of containers on same host
- **Sharing**: IP address, ports, storage volumes
- **Scheduling**: Co-located and co-scheduled
- **Networking**: External and internal connectivity

### ACR Tasks
- **Quick Task**: Build and push on-demand
- **Auto Triggered**: Source commit, base image update, schedule
- **Multi-step**: Complex workflows with multiple steps
- **Platform**: Linux, Windows, ARM builds

### Container Apps Environment
- **Boundary**: Logical boundary for container apps
- **Networking**: VNet integration, custom domains
- **Monitoring**: Log Analytics workspace
- **Dapr**: Distributed application runtime

### Scaling Strategies
- **ACI**: Manual scaling (instance count)
- **Container Apps**: Auto-scale with KEDA (0-N replicas)
- **Triggers**: HTTP, Queue, CPU, Memory, Custom, Cron
- **Scale to Zero**: Container Apps only

### Storage Options
- **Azure Files**: Persistent SMB share
- **Empty Directory**: Temporary storage
- **Secret**: Secure credential storage
- **Container Apps Storage**: Persistent volumes

### Best Practices
1. **Use ACR Premium** for geo-replication and VNet
2. **Implement health checks** for container readiness
3. **Use minimal base images** (Alpine, Distroless)
4. **Scan images** for vulnerabilities regularly
5. **Use managed identities** instead of credentials
6. **Store secrets in Key Vault** not environment vars
7. **Implement retry logic** for resilience
8. **Use Container Apps** for microservices over ACI
9. **Enable logging** to Log Analytics
10. **Set resource limits** (CPU, Memory) appropriately
