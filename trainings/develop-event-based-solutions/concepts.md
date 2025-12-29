# Event-Based Solutions - Concepts Cheatsheet

## Overview
Azure provides three main services for event-driven architectures: Event Grid for reactive programming, Event Hubs for big data streaming, and Azure Relay for hybrid connectivity.

## Azure Event Services Comparison

```mermaid
graph TB
    subgraph "Event Grid"
        EG[Event Grid<br/>Discrete events<br/>Pub/Sub model<br/>99.99% SLA]
        EGUse[Use for:<br/>React to state changes<br/>Serverless architectures<br/>Event routing]
    end
    
    subgraph "Event Hubs"
        EH[Event Hubs<br/>Streaming events<br/>Big data pipeline<br/>Millions events/sec]
        EHUse[Use for:<br/>Telemetry streaming<br/>Log aggregation<br/>IoT data ingestion]
    end
    
    subgraph "Service Bus"
        SB[Service Bus<br/>Enterprise messaging<br/>Transactional<br/>Ordered delivery]
        SBUse[Use for:<br/>Order processing<br/>Financial transactions<br/>Reliable messaging]
    end
    
    EG --> EGUse
    EH --> EHUse
    SB --> SBUse
```

## Event Grid Architecture

```mermaid
graph TB
    subgraph "Event Sources"
        Storage[Azure Storage<br/>Blob created/deleted]
        Resource[Resource Groups<br/>Resource changes]
        Custom[Custom Topics<br/>Application events]
        IoTHub[IoT Hub<br/>Device messages]
        Functions[Azure Functions<br/>Function events]
    end
    
    subgraph "Event Grid"
        Topic[Topic<br/>Event collection]
        
        Filter[Event Filtering<br/>Subject, event type]
        
        Route[Event Routing<br/>Intelligent delivery]
    end
    
    subgraph "Event Handlers"
        WebHook[Webhook<br/>HTTP endpoint]
        Function[Azure Function<br/>Serverless]
        LogicApp[Logic App<br/>Workflow]
        EventHub[Event Hub<br/>Stream processing]
        Queue[Storage Queue<br/>Async processing]
    end
    
    Storage & Resource & Custom & IoTHub & Functions --> Topic
    Topic --> Filter
    Filter --> Route
    Route --> WebHook & Function & LogicApp & EventHub & Queue
```

## Event Grid Topics Types

```mermaid
graph TB
    subgraph "Topic Types"
        System[System Topics<br/>Azure service events<br/>Built-in publishers<br/>Automatic creation]
        
        Custom[Custom Topics<br/>Application events<br/>Custom publishers<br/>Manual creation]
        
        Partner[Partner Topics<br/>Third-party events<br/>SaaS integrations<br/>Partner managed]
        
        Domain[Domain Topics<br/>Multiple related topics<br/>Centralized management<br/>Enterprise scale]
    end
    
    System -.Examples.-> Ex1[Storage events<br/>VM events<br/>Resource events]
    Custom -.Examples.-> Ex2[Order placed<br/>Payment processed<br/>User registered]
    Partner -.Examples.-> Ex3[Auth0<br/>SAP<br/>Microsoft Graph]
```

## Event Schema (CloudEvents)

```mermaid
graph LR
    subgraph "CloudEvents Schema"
        Required[Required Fields<br/>id: unique ID<br/>source: event source<br/>specversion: 1.0<br/>type: event type]
        
        Optional[Optional Fields<br/>time: timestamp<br/>datacontenttype: MIME<br/>subject: resource path]
        
        Data[data:<br/>Event payload<br/>Custom data]
    end
    
    Event[Event Message] --> Required & Optional & Data
```

## Event Grid Delivery & Retry

```mermaid
sequenceDiagram
    participant Source as Event Source
    participant Grid as Event Grid
    participant Handler as Event Handler
    
    Source->>Grid: Publish event
    Grid->>Grid: Store event
    
    Grid->>Handler: Deliver event (Attempt 1)
    Handler-->>Grid: 500 Internal Error
    
    Note over Grid: Retry with exponential backoff
    Grid->>Handler: Deliver event (Attempt 2)
    Handler-->>Grid: 503 Service Unavailable
    
    Note over Grid: Continue retrying
    Grid->>Handler: Deliver event (Attempt 3)
    Handler-->>Grid: 200 OK
    
    Note over Grid,Handler: Event successfully delivered
```

## Event Grid Retry Policy

```mermaid
graph TB
    subgraph "Retry Configuration"
        MaxAttempts[Max Delivery Attempts<br/>Default: 30<br/>Range: 1-30]
        
        TTL[Event Time to Live<br/>Default: 1440 minutes 24h<br/>Range: 1-1440 min]
    end
    
    subgraph "Retry Schedule"
        Attempt1[Attempt 1: Immediate]
        Attempt2[Attempt 2: 10 sec]
        Attempt3[Attempt 3: 30 sec]
        Attempt4[Attempt 4: 1 min]
        Attempt5[Attempt 5+: 5 min<br/>Max backoff]
    end
    
    subgraph "Final State"
        Success[Success:<br/>Event delivered]
        
        DeadLetter[Failed:<br/>Send to dead-letter<br/>if configured]
        
        Drop[Failed:<br/>Drop event<br/>if no dead-letter]
    end
    
    Attempt1 --> Attempt2 --> Attempt3 --> Attempt4 --> Attempt5
    Attempt5 --> Success
    Attempt5 --> DeadLetter
    Attempt5 --> Drop
```

## Event Hubs Architecture

```mermaid
graph TB
    subgraph "Event Publishers"
        IoT[IoT Devices<br/>Telemetry data]
        Apps[Applications<br/>Log data]
        Sensors[Sensors<br/>Real-time data]
    end
    
    subgraph "Event Hubs"
        Namespace[Event Hubs Namespace<br/>Container]
        
        Hub[Event Hub<br/>Stream endpoint]
        
        Partitions[Partitions<br/>Parallel processing<br/>2-32 partitions]
        
        CG[Consumer Groups<br/>Multiple consumers<br/>Independent views]
    end
    
    subgraph "Event Consumers"
        StreamAnalytics[Stream Analytics<br/>Real-time analytics]
        Functions[Azure Functions<br/>Event processing]
        Databricks[Databricks<br/>Big data processing]
        Storage[Capture to Storage<br/>Long-term storage]
    end
    
    IoT & Apps & Sensors --> Hub
    Hub --> Partitions
    Partitions --> CG
    CG --> StreamAnalytics & Functions & Databricks & Storage
```

## Event Hubs Partitions

```mermaid
graph TB
    subgraph "Event Hub with 4 Partitions"
        P0[Partition 0<br/>Event 1, 5, 9...]
        P1[Partition 1<br/>Event 2, 6, 10...]
        P2[Partition 2<br/>Event 3, 7, 11...]
        P3[Partition 3<br/>Event 4, 8, 12...]
    end
    
    subgraph "Partition Key"
        Key[Partition Key<br/>deviceId, userId<br/>Same key → Same partition<br/>Ordered within partition]
    end
    
    subgraph "Consumer"
        C1[Consumer 1<br/>Reads P0, P1]
        C2[Consumer 2<br/>Reads P2, P3]
    end
    
    Key --> P0 & P1 & P2 & P3
    P0 & P1 --> C1
    P2 & P3 --> C2
```

## Event Hubs Capture

```mermaid
sequenceDiagram
    participant Producer
    participant EH as Event Hub
    participant Capture
    participant Blob as Blob Storage
    participant ADLS as Data Lake Storage
    
    Producer->>EH: Send events
    EH->>EH: Buffer events
    
    Note over EH,Capture: Time or size window reached
    
    EH->>Capture: Trigger capture
    Capture->>Capture: Create Avro file
    
    par Store to Blob
        Capture->>Blob: Write Avro file
    and Store to ADLS
        Capture->>ADLS: Write Avro file
    end
    
    Note over Capture,ADLS: Events persisted for batch processing
```

## Event Hubs Throughput Units

```mermaid
graph LR
    subgraph "Standard Tier"
        TU[Throughput Units TU<br/>1-20 TUs manual<br/>20-40 TUs auto-inflate]
        
        Ingress[Ingress<br/>1 MB/sec per TU<br/>1000 events/sec per TU]
        
        Egress[Egress<br/>2 MB/sec per TU<br/>4096 events/sec per TU]
    end
    
    subgraph "Premium/Dedicated Tiers"
        PU[Processing Units PU<br/>Premium: 1-16 PUs<br/>Dedicated: Full cluster]
        
        Higher[Higher Limits<br/>CPU-based scaling<br/>Guaranteed capacity]
    end
    
    TU --> Ingress & Egress
    PU --> Higher
```

## Consumer Groups

```mermaid
graph TB
    subgraph "Event Hub"
        Stream[Event Stream<br/>Partitions 0-3]
    end
    
    subgraph "Consumer Group 1: $Default"
        C1[Consumer 1<br/>Stream Analytics<br/>Real-time alerts]
    end
    
    subgraph "Consumer Group 2: Analytics"
        C2[Consumer 2<br/>Databricks<br/>Batch processing]
    end
    
    subgraph "Consumer Group 3: Archive"
        C3[Consumer 3<br/>Storage<br/>Long-term storage]
    end
    
    Stream --> C1 & C2 & C3
    
    Note[Each consumer group has independent view<br/>Max 5 consumer groups Standard<br/>Max 20 consumer groups Premium]
```

## Checkpoint and Offset Management

```mermaid
sequenceDiagram
    participant Consumer
    participant EventHub as Event Hub
    participant Storage as Checkpoint Storage
    
    Consumer->>EventHub: Read events from offset 100
    EventHub-->>Consumer: Events 100-110
    Consumer->>Consumer: Process events
    Consumer->>Storage: Store checkpoint offset=110
    
    Note over Consumer: Consumer restarts
    
    Consumer->>Storage: Get last checkpoint
    Storage-->>Consumer: offset=110
    Consumer->>EventHub: Resume from offset 110
    EventHub-->>Consumer: Events 110+
    
    Note over Consumer,EventHub: No duplicate processing
```

## Event Hubs vs Event Grid

```mermaid
graph TB
    subgraph "Event Grid"
        EGChar[Characteristics:<br/>Discrete events<br/>Push model<br/>At-least-once delivery<br/>24-hour retention]
        
        EGScenario[Best for:<br/>Resource state changes<br/>Serverless workflows<br/>System integration]
    end
    
    subgraph "Event Hubs"
        EHChar[Characteristics:<br/>Streaming events<br/>Pull model<br/>Multiple consumers<br/>1-90 days retention]
        
        EHScenario[Best for:<br/>Telemetry streams<br/>Big data ingestion<br/>Time-series data]
    end
```

## Azure Relay Architecture

```mermaid
graph TB
    subgraph "On-Premises"
        OnPrem[On-Prem Service<br/>Behind firewall<br/>No inbound ports]
    end
    
    subgraph "Azure Relay"
        Relay[Azure Relay<br/>Hybrid connection<br/>WCF Relay]
    end
    
    subgraph "Cloud"
        CloudApp[Cloud Application<br/>Azure or external]
    end
    
    OnPrem -.Outbound connection.-> Relay
    CloudApp --> Relay
    Relay -.Bi-directional.-> OnPrem
    
    Note[No VPN or ExpressRoute needed<br/>No inbound firewall rules]
```

## Event-Driven Patterns

```mermaid
graph TB
    subgraph "Common Patterns"
        PubSub[Pub/Sub<br/>Event Grid<br/>1:Many distribution]
        
        EventStream[Event Streaming<br/>Event Hubs<br/>Continuous flow]
        
        CQRS[CQRS<br/>Command Query Separation<br/>Event sourcing]
        
        Saga[Saga Pattern<br/>Distributed transactions<br/>Compensating actions]
    end
    
    subgraph "Use Cases"
        Notify[Notifications<br/>State changes]
        
        Analytics[Analytics<br/>Real-time insights]
        
        Audit[Audit Trail<br/>Event log]
        
        Workflow[Workflow<br/>Orchestration]
    end
    
    PubSub --> Notify & Workflow
    EventStream --> Analytics
    CQRS --> Audit
    Saga --> Workflow
```

## Event Filtering

```mermaid
graph TB
    subgraph "Event Grid Filters"
        Subject[Subject Filter<br/>Prefix/Suffix matching<br/>Example: /blobServices/*/containers/images]
        
        EventType[Event Type Filter<br/>Filter by event type<br/>Example: Microsoft.Storage.BlobCreated]
        
        Advanced[Advanced Filter<br/>Operators: Equals, Contains, In<br/>Number, String, Boolean]
    end
    
    subgraph "Filter Examples"
        Ex1[Subject begins with:<br/>/blobServices/default/containers/images]
        
        Ex2[Event type equals:<br/>Microsoft.Storage.BlobCreated]
        
        Ex3[Data.contentType in:<br/>[image/png, image/jpeg]]
    end
    
    Subject -.Example.-> Ex1
    EventType -.Example.-> Ex2
    Advanced -.Example.-> Ex3
```

## Dead-Letter Configuration

```mermaid
graph TB
    subgraph "Event Grid Subscription"
        Delivery[Delivery Attempts<br/>Max 30 attempts<br/>24 hour TTL]
    end
    
    subgraph "Failure Handling"
        Failed[Delivery Failed<br/>All retries exhausted<br/>Or TTL expired]
        
        DeadLetter[Dead-Letter Storage<br/>Blob container<br/>For investigation]
        
        Alert[Monitoring Alert<br/>Notify on failures]
    end
    
    subgraph "Event Analysis"
        Review[Review Failed Events<br/>Fix handler issues<br/>Reprocess if needed]
    end
    
    Delivery --> Failed
    Failed --> DeadLetter
    DeadLetter --> Alert
    DeadLetter --> Review
```

## Security for Event Services

```mermaid
graph TB
    subgraph "Event Grid Security"
        EGWebhook[Webhook Validation<br/>Handshake validation]
        
        EGAAD[Entra ID Auth<br/>Managed identity<br/>Service principal]
        
        EGKey[Access Keys<br/>Topic keys<br/>Subscription keys]
    end
    
    subgraph "Event Hubs Security"
        EHSAS[Shared Access Signature<br/>Send, Listen, Manage]
        
        EHAAD[Entra ID Auth<br/>RBAC roles<br/>Managed identity]
        
        EHVNet[Virtual Network<br/>Service endpoints<br/>Private endpoints]
    end
    
    subgraph "Encryption"
        Transit[In Transit<br/>TLS 1.2]
        Rest[At Rest<br/>Microsoft-managed<br/>Customer-managed keys]
    end
```

## Key Concepts Summary

### Event Grid
- **Purpose**: Reactive event-driven programming
- **Model**: Push-based, pub/sub
- **Delivery**: At-least-once, 24-hour retention
- **Use Cases**: State changes, serverless workflows, integrations

### Event Hubs
- **Purpose**: Big data streaming and ingestion
- **Model**: Pull-based, multiple consumers
- **Retention**: 1-90 days
- **Use Cases**: Telemetry, logs, IoT, time-series data

### Event Grid Topics
- **System**: Built-in Azure service events
- **Custom**: Application-generated events
- **Partner**: Third-party SaaS events
- **Domain**: Enterprise-scale topic management

### Event Hubs Components
- **Namespace**: Container for Event Hubs
- **Partitions**: Parallel processing (2-32)
- **Consumer Groups**: Independent event views
- **Capture**: Automatic storage to Blob/ADLS

### Event Grid Delivery
- **Retry**: Exponential backoff, up to 30 attempts
- **TTL**: 24-hour event lifetime
- **Dead-Letter**: Failed event storage
- **Filtering**: Subject, event type, advanced filters

### Event Hubs Scaling
- **Throughput Units**: 1-40 TUs (Standard)
- **Processing Units**: 1-16 PUs (Premium)
- **Auto-Inflate**: Automatic scaling
- **Dedicated**: Full cluster isolation

### Consumer Patterns
- **Checkpointing**: Track read position
- **Offset Management**: Resume from last position
- **Multiple Readers**: Via consumer groups
- **Competing Consumers**: Balance partitions

### Best Practices
1. **Use Event Grid** for reactive programming
2. **Use Event Hubs** for high-volume streaming
3. **Implement dead-lettering** for failed events
4. **Use consumer groups** for independent processing
5. **Set appropriate partition count** for parallelism
6. **Implement checkpoint** strategy for Event Hubs
7. **Filter events** at subscription level
8. **Use managed identities** for authentication
9. **Enable capture** for Event Hubs long-term storage
10. **Monitor with Azure Monitor** for insights
