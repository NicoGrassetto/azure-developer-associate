# Azure App Service Web Apps - Concepts Cheatsheet

## Overview
Azure App Service is an HTTP-based PaaS service for hosting web applications, REST APIs, and mobile backends with built-in auto-scaling, CI/CD, and deployment slots.

## Core Architecture

```mermaid
graph TB
    subgraph "Azure App Service Architecture"
        User[Users/Clients]
        LB[Load Balancer]
        
        subgraph "App Service Plan"
            VM1[VM Instance 1]
            VM2[VM Instance 2]
            VM3[VM Instance 3]
        end
        
        subgraph "Deployment Slots"
            Prod[Production Slot]
            Stage[Staging Slot]
            Dev[Development Slot]
        end
        
        User --> LB
        LB --> VM1 & VM2 & VM3
        VM1 & VM2 & VM3 --> Prod
        VM1 & VM2 & VM3 --> Stage
        VM1 & VM2 & VM3 --> Dev
    end
```

## App Service Plans & Pricing Tiers

```mermaid
graph LR
    subgraph "Pricing Tiers"
        Free[Free/Shared<br/>Shared VMs<br/>No Scale Out]
        Basic[Basic<br/>Dedicated VMs<br/>Manual Scale]
        Standard[Standard<br/>Dedicated VMs<br/>Auto Scale<br/>Deployment Slots]
        Premium[Premium<br/>More Power<br/>VNet Integration]
        Isolated[Isolated<br/>Dedicated VNet<br/>Maximum Isolation]
    end
    
    Free --> Basic
    Basic --> Standard
    Standard --> Premium
    Premium --> Isolated
```

## Deployment Methods

```mermaid
graph TB
    Code[Application Code]
    
    subgraph "Deployment Options"
        Azure[Azure DevOps]
        GitHub[GitHub Actions]
        Bitbucket[Bitbucket]
        Local[Local Git]
        FTP[FTP/FTPS]
        ZIP[ZIP Deploy]
        Container[Container<br/>ACR/Docker Hub]
    end
    
    subgraph "App Service"
        App[Web App]
    end
    
    Code --> Azure & GitHub & Bitbucket & Local & FTP & ZIP & Container
    Azure & GitHub & Bitbucket & Local & FTP & ZIP & Container --> App
```

## Deployment Slots Workflow

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant Stage as Staging Slot
    participant Prod as Production Slot
    participant Users as End Users
    
    Dev->>Stage: Deploy new version
    Stage->>Stage: Test & Validate
    Note over Stage: Warm up instances
    Dev->>Stage: Swap with Production
    Stage-->>Prod: Swap slots
    Prod-->>Stage: Previous version to staging
    Users->>Prod: Access new version
    Note over Prod,Stage: Zero downtime deployment
```

## Scaling Options

```mermaid
graph TB
    subgraph "Scaling Strategies"
        ScaleUp[Scale Up/Down<br/>Vertical Scaling<br/>More CPU/RAM]
        ScaleOut[Scale Out/In<br/>Horizontal Scaling<br/>More Instances]
        
        subgraph "Scale Out Triggers"
            CPU[CPU Percentage]
            Memory[Memory Usage]
            HTTP[HTTP Queue Length]
            Custom[Custom Metrics]
        end
        
        subgraph "Auto-Scale Rules"
            Rule1[Scale out when CPU > 70%]
            Rule2[Scale in when CPU < 30%]
            Rule3[Min: 2, Max: 10 instances]
        end
    end
    
    ScaleOut --> CPU & Memory & HTTP & Custom
    CPU & Memory & HTTP & Custom --> Rule1 & Rule2 & Rule3
```

## Application Settings & Configuration

```mermaid
graph LR
    subgraph "Configuration Sources"
        Portal[Azure Portal]
        CLI[Azure CLI]
        ARM[ARM Templates]
        AppConfig[App Configuration]
    end
    
    subgraph "App Settings"
        Env[Environment Variables]
        ConnStr[Connection Strings]
        General[General Settings]
        Path[Path Mappings]
    end
    
    subgraph "App Service"
        Runtime[Runtime Stack]
        App[Application Code]
    end
    
    Portal & CLI & ARM & AppConfig --> Env & ConnStr & General & Path
    Env & ConnStr & General & Path --> Runtime
    Runtime --> App
```

## Continuous Deployment Pipeline

```mermaid
graph LR
    subgraph "CI/CD Pipeline"
        Code[Code Repository]
        Build[Build Phase<br/>Compile & Test]
        Artifact[Build Artifact]
        Deploy[Deploy Phase]
        
        subgraph "Deployment Targets"
            Dev[Development]
            Stage[Staging]
            Prod[Production]
        end
    end
    
    Code -->|Push/PR| Build
    Build -->|Success| Artifact
    Artifact --> Deploy
    Deploy --> Dev
    Dev -->|Validation| Stage
    Stage -->|Swap| Prod
```

## Authentication & Authorization

```mermaid
graph TB
    User[User Request]
    
    subgraph "App Service Authentication"
        EasyAuth[Easy Auth Module]
        
        subgraph "Identity Providers"
            AAD[Microsoft Entra ID]
            Facebook[Facebook]
            Google[Google]
            Twitter[Twitter]
            Custom[Custom OpenID]
        end
    end
    
    subgraph "Application"
        App[Web App Code]
        Claims[User Claims]
    end
    
    User --> EasyAuth
    EasyAuth --> AAD & Facebook & Google & Twitter & Custom
    AAD & Facebook & Google & Twitter & Custom -->|Authenticated| App
    App --> Claims
```

## Monitoring & Diagnostics

```mermaid
graph TB
    subgraph "Application"
        App[Web App]
    end
    
    subgraph "Diagnostics Logs"
        AppLog[Application Logging]
        WebLog[Web Server Logging]
        ErrorLog[Detailed Error Messages]
        Deploy[Deployment Logging]
        Trace[Failed Request Tracing]
    end
    
    subgraph "Monitoring Services"
        AppInsights[Application Insights]
        Metrics[Azure Metrics]
        Alerts[Azure Alerts]
        LogAnalytics[Log Analytics]
    end
    
    App --> AppLog & WebLog & ErrorLog & Deploy & Trace
    AppLog & WebLog & ErrorLog & Deploy & Trace --> AppInsights & LogAnalytics
    AppInsights & Metrics --> Alerts
```

## Networking Features

```mermaid
graph TB
    subgraph "Inbound Features"
        InIP[App-assigned Address]
        AccessRestr[Access Restrictions]
        ServiceEndpoint[Service Endpoints]
        PrivateEndpoint[Private Endpoints]
    end
    
    subgraph "App Service"
        App[Web App]
    end
    
    subgraph "Outbound Features"
        VNetInt[VNet Integration]
        HybridConn[Hybrid Connections]
        Gateway[Gateway-required VNet]
    end
    
    subgraph "External Services"
        VNet[Virtual Network]
        OnPrem[On-Premises]
        Azure[Azure Services]
    end
    
    InIP & AccessRestr & ServiceEndpoint & PrivateEndpoint --> App
    App --> VNetInt & HybridConn & Gateway
    VNetInt & HybridConn & Gateway --> VNet & OnPrem & Azure
```

## Key Concepts Summary

### App Service Plans
- **Definition**: Compute resources container for web apps
- **Pricing Tiers**: Free, Shared, Basic, Standard, Premium, Isolated
- **Scale Unit**: All apps in plan scale together

### Deployment Slots
- **Purpose**: Zero-downtime deployments
- **Features**: Separate hostnames, swap functionality, traffic routing
- **Requirement**: Standard tier or higher

### Auto-Scaling
- **Scale Up/Down**: Change VM size (vertical)
- **Scale Out/In**: Change instance count (horizontal)
- **Triggers**: CPU, Memory, HTTP queue, Custom metrics

### Networking
- **Inbound**: Access restrictions, Private endpoints, Service endpoints
- **Outbound**: VNet integration, Hybrid connections
- **Isolation**: App Service Environment (ASE)

### Configuration
- **App Settings**: Environment variables
- **Connection Strings**: Database connections
- **Slot Settings**: Stick to slot or swap with app

### Monitoring
- **Application Insights**: APM and analytics
- **Diagnostic Logs**: Application and web server logs
- **Metrics**: CPU, Memory, HTTP requests
- **Alerts**: Proactive monitoring

### Security
- **Authentication**: Easy Auth with multiple providers
- **Managed Identity**: Access Azure resources without credentials
- **SSL/TLS**: Custom domains with certificates
- **Key Vault**: Store secrets securely

## Best Practices

1. **Use Deployment Slots** for staging and testing
2. **Enable Auto-Scale** for production workloads
3. **Configure Health Checks** for instance monitoring
4. **Use VNet Integration** for secure backend access
5. **Implement Application Insights** for monitoring
6. **Store secrets in Key Vault** via Managed Identity
7. **Use Slot Settings** for environment-specific config
8. **Enable Diagnostic Logs** for troubleshooting
