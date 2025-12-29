# Azure Functions - Concepts Cheatsheet

## Overview
Azure Functions is a serverless compute service that enables event-driven code execution without managing infrastructure. Pay only for the compute time you consume.

## Azure Functions Architecture

```mermaid
graph TB
    subgraph "Event Sources"
        HTTP[HTTP Request]
        Timer[Timer]
        Queue[Queue Message]
        Blob[Blob Storage]
        EventGrid[Event Grid]
        CosmosDB[Cosmos DB]
        ServiceBus[Service Bus]
    end
    
    subgraph "Azure Functions"
        Trigger[Trigger]
        Function[Function Code]
        Binding[Bindings]
    end
    
    subgraph "Output Destinations"
        DB[Database]
        Storage[Storage]
        Queue2[Queue]
        HTTP2[HTTP Response]
    end
    
    HTTP & Timer & Queue & Blob & EventGrid & CosmosDB & ServiceBus --> Trigger
    Trigger --> Function
    Function --> Binding
    Binding --> DB & Storage & Queue2 & HTTP2
```

## Hosting Plans Comparison

```mermaid
graph TB
    subgraph "Hosting Plans"
        direction LR
        Consumption[Consumption Plan<br/>✓ Pay per execution<br/>✓ Auto-scale<br/>✓ 5 min timeout<br/>✓ 1.5 GB memory]
        
        Flex[Flex Consumption<br/>✓ Pay per execution<br/>✓ High scalability<br/>✓ VNet support<br/>✓ Configurable concurrency]
        
        Premium[Premium Plan<br/>✓ Pre-warmed instances<br/>✓ No cold start<br/>✓ VNet connectivity<br/>✓ Unlimited duration]
        
        Dedicated[Dedicated Plan<br/>✓ Predictable billing<br/>✓ Long-running<br/>✓ App Service features<br/>✓ Manual scale]
        
        Container[Container Apps<br/>✓ Kubernetes-based<br/>✓ Custom containers<br/>✓ Linux only<br/>✓ KEDA scaling]
    end
    
    Consumption -->|Need VNet or<br/>consistent performance| Premium
    Premium -->|Need full control<br/>or existing plan| Dedicated
    Dedicated -->|Need container<br/>flexibility| Container
    Consumption -->|Need advanced<br/>scaling| Flex
```

## Triggers and Bindings

```mermaid
graph LR
    subgraph "Input Bindings"
        IBlobS[Blob Storage]
        IQueue[Queue Storage]
        ITable[Table Storage]
        ICosmos[Cosmos DB]
        IEventHub[Event Hubs]
    end
    
    subgraph "Function"
        Trigger[Trigger Input]
        Code[Function Code]
        Output[Output Binding]
    end
    
    subgraph "Output Bindings"
        OBlobS[Blob Storage]
        OQueue[Queue Storage]
        OTable[Table Storage]
        OCosmos[Cosmos DB]
        OEventHub[Event Hubs]
        OHTTP[HTTP Response]
    end
    
    IBlobS & IQueue & ITable & ICosmos & IEventHub --> Trigger
    Trigger --> Code
    Code --> Output
    Output --> OBlobS & OQueue & OTable & OCosmos & OEventHub & OHTTP
```

## Common Trigger Types

```mermaid
graph TB
    subgraph "Trigger Types"
        direction TB
        
        HTTP[HTTP Trigger<br/>REST APIs, Webhooks]
        Timer[Timer Trigger<br/>Scheduled Jobs, Cron]
        Queue[Queue Trigger<br/>Async Processing]
        Blob[Blob Trigger<br/>File Processing]
        EventGrid[Event Grid Trigger<br/>Event-Driven]
        EventHub[Event Hub Trigger<br/>Stream Processing]
        CosmosDB[Cosmos DB Trigger<br/>Change Feed]
        ServiceBus[Service Bus Trigger<br/>Messaging]
    end
    
    subgraph "Use Cases"
        API[Build APIs]
        Schedule[Run Scheduled Tasks]
        Process[Process Queues]
        Transform[Transform Files]
        React[React to Events]
        Stream[Process Streams]
        Sync[Sync Data Changes]
        Message[Handle Messages]
    end
    
    HTTP --> API
    Timer --> Schedule
    Queue --> Process
    Blob --> Transform
    EventGrid --> React
    EventHub --> Stream
    CosmosDB --> Sync
    ServiceBus --> Message
```

## Function App Execution Flow

```mermaid
sequenceDiagram
    participant Event as Event Source
    participant Runtime as Functions Runtime
    participant Function as Function Code
    participant Binding as Output Binding
    participant Dest as Destination
    
    Event->>Runtime: Trigger Event
    Runtime->>Runtime: Scale if needed
    Runtime->>Function: Invoke function
    Note over Function: Execute business logic
    Function->>Binding: Write output
    Binding->>Dest: Send data
    Dest-->>Runtime: Acknowledgment
    Runtime-->>Event: Complete
```

## Durable Functions Patterns

```mermaid
graph TB
    subgraph "Durable Functions Patterns"
        FC[Function Chaining<br/>Sequential Steps]
        FO[Fan-out/Fan-in<br/>Parallel Processing]
        AM[Async HTTP APIs<br/>Long-running Operations]
        Monitor[Monitor<br/>Polling Pattern]
        HI[Human Interaction<br/>Approval Workflows]
    end
    
    subgraph "Components"
        Orchestrator[Orchestrator Function]
        Activity[Activity Functions]
        Client[Client Function]
    end
    
    Client --> Orchestrator
    Orchestrator --> Activity
    
    FC & FO & AM & Monitor & HI -.implements.-> Orchestrator
```

## Function Chaining Pattern

```mermaid
sequenceDiagram
    participant Client
    participant Orchestrator
    participant F1 as Activity 1
    participant F2 as Activity 2
    participant F3 as Activity 3
    
    Client->>Orchestrator: Start workflow
    Orchestrator->>F1: Execute step 1
    F1-->>Orchestrator: Result 1
    Orchestrator->>F2: Execute step 2
    F2-->>Orchestrator: Result 2
    Orchestrator->>F3: Execute step 3
    F3-->>Orchestrator: Result 3
    Orchestrator-->>Client: Final result
```

## Fan-out/Fan-in Pattern

```mermaid
sequenceDiagram
    participant Client
    participant Orchestrator
    participant A1 as Activity 1
    participant A2 as Activity 2
    participant A3 as Activity 3
    
    Client->>Orchestrator: Start workflow
    
    par Parallel Execution
        Orchestrator->>A1: Process batch 1
        Orchestrator->>A2: Process batch 2
        Orchestrator->>A3: Process batch 3
    end
    
    A1-->>Orchestrator: Result 1
    A2-->>Orchestrator: Result 2
    A3-->>Orchestrator: Result 3
    
    Note over Orchestrator: Aggregate results
    Orchestrator-->>Client: Combined result
```

## Cold Start vs Warm Start

```mermaid
graph TB
    subgraph "Cold Start Process"
        CS1[Function Triggered]
        CS2[Allocate Resources]
        CS3[Load Runtime]
        CS4[Load Dependencies]
        CS5[Initialize Function]
        CS6[Execute Code]
    end
    
    subgraph "Warm Start Process"
        WS1[Function Triggered]
        WS2[Execute Code]
    end
    
    CS1 --> CS2 --> CS3 --> CS4 --> CS5 --> CS6
    WS1 --> WS2
    
    CS6 -.High Latency.-> Time1[1-5 seconds]
    WS2 -.Low Latency.-> Time2[< 100ms]
```

## Scaling Behavior

```mermaid
graph LR
    subgraph "Consumption Plan Scaling"
        Event1[Events: 10/sec]
        Event2[Events: 100/sec]
        Event3[Events: 1000/sec]
        
        Inst1[1 Instance]
        Inst2[5 Instances]
        Inst3[20 Instances]
    end
    
    Event1 -->|Low Load| Inst1
    Event2 -->|Medium Load| Inst2
    Event3 -->|High Load| Inst3
    
    Note1[Scale out automatically<br/>based on event load]
    Inst3 --> Note1
```

## Configuration & Settings

```mermaid
graph TB
    subgraph "Function Configuration"
        Host[host.json<br/>Global Settings]
        Local[local.settings.json<br/>Local Development]
        AppSettings[Application Settings<br/>Azure Portal/CLI]
    end
    
    subgraph "Settings Types"
        Runtime[Runtime Version]
        Timeout[Function Timeout]
        Concurrency[Concurrency Limits]
        Extensions[Extension Bundles]
        Logging[Logging Level]
    end
    
    subgraph "Storage"
        Storage[Storage Account<br/>Required for state]
    end
    
    Host & Local & AppSettings --> Runtime & Timeout & Concurrency & Extensions & Logging
    Runtime & Timeout & Concurrency & Extensions & Logging --> Storage
```

## Function App Lifecycle

```mermaid
stateDiagram-v2
    [*] --> Development
    Development --> Testing: Deploy to test
    Testing --> Staging: Tests pass
    Staging --> Production: Manual approval
    Production --> Monitoring: Live traffic
    Monitoring --> [*]: Function complete
    Monitoring --> Development: Issues found
    
    note right of Development
        Local development
        Write function code
        Configure triggers
    end note
    
    note right of Production
        Scaled execution
        Monitoring enabled
        Auto-scale active
    end note
```

## Bindings Configuration Example

```mermaid
graph LR
    subgraph "function.json"
        Config[{<br/>'bindings': [<br/>  {<br/>    'type': 'queueTrigger',<br/>    'name': 'msg',<br/>    'queueName': 'orders'<br/>  },<br/>  {<br/>    'type': 'table',<br/>    'name': 'outputTable',<br/>    'tableName': 'Orders',<br/>    'direction': 'out'<br/>  }<br/>]<br/>}]
    end
    
    QueueTrigger[Queue Trigger<br/>Input] --> FunctionCode[Function Code]
    FunctionCode --> TableOutput[Table Storage<br/>Output]
```

## Authentication & Security

```mermaid
graph TB
    subgraph "Security Features"
        AuthLevel[Authorization Level<br/>Anonymous, Function, Admin]
        ManagedID[Managed Identity<br/>Access Azure Resources]
        APIKey[Function Keys<br/>API Security]
        AAD[Microsoft Entra ID<br/>Enterprise Auth]
    end
    
    subgraph "Function App"
        Function[Function Code]
    end
    
    subgraph "Protected Resources"
        KeyVault[Key Vault]
        Storage[Storage Account]
        Database[SQL Database]
    end
    
    AuthLevel & APIKey & AAD --> Function
    Function --> ManagedID
    ManagedID --> KeyVault & Storage & Database
```

## Monitoring & Diagnostics

```mermaid
graph TB
    subgraph "Function App"
        Func[Function Execution]
        Logs[Logs Output]
        Metrics[Metrics]
    end
    
    subgraph "Monitoring Tools"
        AppInsights[Application Insights<br/>Telemetry & Analytics]
        LiveMetrics[Live Metrics Stream<br/>Real-time Monitoring]
        Alerts[Azure Alerts<br/>Proactive Notifications]
    end
    
    subgraph "Analysis"
        Perf[Performance Analysis]
        Failures[Failure Analysis]
        Dependencies[Dependency Tracking]
        Custom[Custom Events]
    end
    
    Func --> Logs & Metrics
    Logs & Metrics --> AppInsights
    AppInsights --> LiveMetrics & Alerts
    AppInsights --> Perf & Failures & Dependencies & Custom
```

## Key Concepts Summary

### Triggers
- **Definition**: What causes a function to run
- **Types**: HTTP, Timer, Queue, Blob, Event Grid, Event Hub, Cosmos DB, Service Bus
- **Limit**: One trigger per function

### Bindings
- **Input Bindings**: Read data from external sources
- **Output Bindings**: Write data to external destinations
- **Declarative**: Configured in function.json or attributes
- **No Connection Code**: Framework handles connections

### Hosting Plans
- **Consumption**: Pay-per-execution, auto-scale
- **Flex Consumption**: Enhanced scaling with VNet support
- **Premium**: Pre-warmed, VNet, no cold start
- **Dedicated**: App Service plan, predictable billing
- **Container Apps**: Kubernetes-based, custom containers

### Durable Functions
- **Orchestration**: Coordinate multiple functions
- **State Management**: Automatic state persistence
- **Patterns**: Chaining, Fan-out/Fan-in, Async HTTP, Monitor
- **Use Cases**: Long-running workflows, human interaction

### Scaling
- **Automatic**: Based on event rate (Consumption/Premium)
- **Manual**: Fixed instances (Dedicated)
- **Per-function**: HTTP scales independently
- **Concurrent Executions**: Configurable per trigger type

### Configuration
- **host.json**: Global function app settings
- **local.settings.json**: Local development settings
- **Application Settings**: Environment variables in Azure
- **Connection Strings**: Stored in app settings or Key Vault

### Security
- **Authorization Levels**: Anonymous, Function, Admin
- **Function Keys**: Secure API access
- **Managed Identity**: Access Azure resources without credentials
- **API Management**: Enterprise API gateway

### Best Practices
1. **Use Consumption Plan** for event-driven, variable workloads
2. **Use Premium Plan** to avoid cold starts
3. **Keep functions small** and single-purpose
4. **Use Durable Functions** for complex workflows
5. **Configure timeouts** appropriately
6. **Implement retry logic** for resilience
7. **Use Application Insights** for monitoring
8. **Store secrets in Key Vault** via Managed Identity
9. **Use async/await** for I/O operations
10. **Optimize dependencies** to reduce cold start time
