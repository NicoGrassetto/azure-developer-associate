# Azure Cosmos DB - Concepts Cheatsheet

## Overview
Azure Cosmos DB is a globally distributed, multi-model NoSQL database with guaranteed low latency, elastic scalability, and comprehensive SLAs.

## Cosmos DB Architecture

```mermaid
graph TB
    subgraph "Global Distribution"
        Region1[Region 1<br/>Primary]
        Region2[Region 2<br/>Replica]
        Region3[Region 3<br/>Replica]
        Region4[Region 4<br/>Replica]
    end
    
    subgraph "Cosmos DB Account"
        Account[Database Account]
        
        subgraph "Databases"
            DB1[Database 1]
            DB2[Database 2]
        end
        
        subgraph "Containers"
            C1[Container 1]
            C2[Container 2]
            C3[Container 3]
        end
        
        subgraph "Items"
            Items[JSON Documents]
        end
    end
    
    Region1 & Region2 & Region3 & Region4 -.Replicate.-> Account
    Account --> DB1 & DB2
    DB1 --> C1 & C2
    DB2 --> C3
    C1 & C2 & C3 --> Items
```

## Resource Hierarchy

```mermaid
graph LR
    subgraph "Cosmos DB Hierarchy"
        Account[Cosmos DB Account<br/>Unique DNS name<br/>Global distribution]
        
        Database[Database<br/>Namespace<br/>Management unit]
        
        Container[Container<br/>Scalability unit<br/>Partition key required]
        
        Items[Items<br/>Documents, Rows, Nodes]
        
        Account --> Database
        Database --> Container
        Container --> Items
    end
```

## Consistency Levels

```mermaid
graph TB
    subgraph "Consistency Spectrum"
        Strong[Strong<br/>Linearizability<br/>Highest latency<br/>Reads always return latest]
        
        Bounded[Bounded Staleness<br/>Prefix + lag guarantee<br/>K versions or T time behind]
        
        Session[Session<br/>DEFAULT<br/>Read your writes<br/>Same session guaranteed]
        
        Consistent[Consistent Prefix<br/>In-order reads<br/>No out-of-order]
        
        Eventual[Eventual<br/>Lowest latency<br/>Eventual convergence]
    end
    
    Strong -->|Less consistency| Bounded
    Bounded -->|Less consistency| Session
    Session -->|Less consistency| Consistent
    Consistent -->|Less consistency| Eventual
    
    Strong -.->|Higher latency<br/>Lower availability| Cost[Trade-offs]
    Eventual -.->|Lower latency<br/>Higher availability| Cost
```

## Consistency Levels Visualization

```mermaid
sequenceDiagram
    participant Client
    participant Region1 as Region 1 (Primary)
    participant Region2 as Region 2
    participant Region3 as Region 3
    
    Note over Client,Region3: Write Operation
    Client->>Region1: Write (v1)
    Region1->>Region2: Replicate
    Region1->>Region3: Replicate
    
    Note over Client,Region3: Strong Consistency
    Client->>Region1: Read
    Region1-->>Client: v1 (waits for majority)
    
    Note over Client,Region3: Session Consistency
    Client->>Region1: Read (same session)
    Region1-->>Client: v1 (guaranteed)
    
    Note over Client,Region3: Eventual Consistency
    Client->>Region3: Read (different session)
    Region3-->>Client: v0 or v1 (eventually v1)
```

## Partitioning Strategy

```mermaid
graph TB
    subgraph "Container"
        PartitionKey[Partition Key: /category]
    end
    
    subgraph "Logical Partitions"
        L1[Electronics<br/>Max 20 GB]
        L2[Books<br/>Max 20 GB]
        L3[Clothing<br/>Max 20 GB]
    end
    
    subgraph "Physical Partitions"
        P1[Physical Partition 1<br/>10,000 RU/s<br/>50 GB]
        P2[Physical Partition 2<br/>10,000 RU/s<br/>50 GB]
        P3[Physical Partition 3<br/>10,000 RU/s<br/>50 GB]
    end
    
    PartitionKey --> L1 & L2 & L3
    L1 & L2 --> P1
    L3 --> P2
```

## Request Units (RU) Model

```mermaid
graph LR
    subgraph "Operation Costs"
        Read1KB[Read 1 KB item<br/>by ID + Partition Key<br/>= 1 RU]
        
        Write1KB[Write 1 KB item<br/>= 5 RUs]
        
        Query[Query<br/>Variable RUs<br/>based on complexity]
    end
    
    subgraph "Throughput Modes"
        Provisioned[Provisioned<br/>Fixed RU/s<br/>Hourly billing]
        
        Autoscale[Autoscale<br/>Auto-scale RU/s<br/>Based on load]
        
        Serverless[Serverless<br/>Pay per request<br/>No provisioning]
    end
    
    Read1KB & Write1KB & Query -.consume.-> Provisioned & Autoscale & Serverless
```

## Throughput Models Comparison

```mermaid
graph TB
    subgraph "Provisioned Throughput"
        P1[Fixed RU/s: 1000]
        P2[Predictable performance]
        P3[Best for: Steady traffic]
        P4[Cost: Based on provisioned]
    end
    
    subgraph "Autoscale Throughput"
        A1[Auto-scale: 1000-10000 RU/s]
        A2[Scale automatically]
        A3[Best for: Variable traffic]
        A4[Cost: Based on max scale]
    end
    
    subgraph "Serverless"
        S1[No provisioning]
        S2[Pay per request]
        S3[Best for: Unpredictable/low traffic]
        S4[Cost: Per-request]
        S5[Limit: 5000 RU/s max]
    end
```

## Partition Key Selection

```mermaid
graph TB
    subgraph "Good Partition Keys"
        Good1[High Cardinality<br/>Many distinct values]
        Good2[Even Distribution<br/>Balanced request load]
        Good3[Query Pattern<br/>Used in WHERE clause]
    end
    
    subgraph "Bad Partition Keys"
        Bad1[Low Cardinality<br/>Few distinct values]
        Bad2[Hot Partitions<br/>Uneven distribution]
        Bad3[Date/Time<br/>Sequential writes]
    end
    
    subgraph "Examples"
        GoodEx[✓ userId<br/>✓ tenantId<br/>✓ deviceId]
        BadEx[✗ status<br/>✗ country<br/>✗ createdDate]
    end
    
    Good1 & Good2 & Good3 --> GoodEx
    Bad1 & Bad2 & Bad3 --> BadEx
```

## Query Optimization

```mermaid
graph LR
    subgraph "Query Types"
        PointRead[Point Read<br/>ID + Partition Key<br/>1 RU for 1 KB]
        
        InPartition[In-Partition Query<br/>Single partition<br/>Lower RU cost]
        
        CrossPartition[Cross-Partition Query<br/>Multiple partitions<br/>Higher RU cost]
    end
    
    subgraph "Optimization"
        Index[Indexing Policy<br/>Include/Exclude paths]
        
        Projection[SELECT specific fields<br/>Reduce bandwidth]
        
        Filter[Filter on partition key<br/>Reduce scope]
    end
    
    PointRead -.Best.-> Performance[Query Performance]
    InPartition -.Good.-> Performance
    CrossPartition -.Expensive.-> Performance
    
    Index & Projection & Filter -.Improve.-> Performance
```

## Indexing Policy

```mermaid
graph TB
    subgraph "Indexing Modes"
        Auto[Automatic: true<br/>Index all properties]
        None[Automatic: false<br/>No indexing]
    end
    
    subgraph "Index Types"
        Range[Range Index<br/>Order by, >, <, >=, <=]
        Spatial[Spatial Index<br/>GeoSpatial queries]
    end
    
    subgraph "Path Policy"
        Include[Included Paths<br/>Paths to index]
        Exclude[Excluded Paths<br/>Paths to skip]
    end
    
    Auto --> Range & Spatial
    Range & Spatial --> Include & Exclude
    
    Note1[Default: All paths included<br/>Exclude to reduce write RUs]
```

## Change Feed Pattern

```mermaid
sequenceDiagram
    participant App as Application
    participant Container as Cosmos Container
    participant CF as Change Feed
    participant Processor as Change Feed Processor
    participant Consumer as Consumer App
    
    App->>Container: Write/Update/Delete
    Container->>CF: Record change
    CF->>Processor: Poll for changes
    Processor->>Processor: Track progress (lease)
    Processor->>Consumer: Process change
    Consumer->>Consumer: Execute business logic
    
    Note over Processor: Continues from last checkpoint
```

## Change Feed Use Cases

```mermaid
graph TB
    subgraph "Cosmos DB Container"
        Changes[Change Feed]
    end
    
    subgraph "Use Cases"
        Event[Event Sourcing<br/>Publish events]
        Cache[Cache Invalidation<br/>Update cache]
        Search[Search Index<br/>Update search]
        Analytics[Real-time Analytics<br/>Stream processing]
        Audit[Audit Log<br/>Track changes]
        Replicate[Data Replication<br/>Copy to another DB]
    end
    
    Changes --> Event & Cache & Search & Analytics & Audit & Replicate
```

## Multi-Region Write Configuration

```mermaid
graph TB
    subgraph "Single-Region Write"
        Primary[Primary Region<br/>Write]
        Secondary1[Secondary Region<br/>Read Only]
        Secondary2[Secondary Region<br/>Read Only]
        
        Primary -.Replicate.-> Secondary1 & Secondary2
    end
    
    subgraph "Multi-Region Write"
        Region1[Region 1<br/>Read + Write]
        Region2[Region 2<br/>Read + Write]
        Region3[Region 3<br/>Read + Write]
        
        Region1 -.Sync.-> Region2 & Region3
        Region2 -.Sync.-> Region1 & Region3
        Region3 -.Sync.-> Region1 & Region2
    end
```

## Cosmos DB APIs

```mermaid
graph TB
    subgraph "Cosmos DB Account"
        Account[Single Account<br/>Choose ONE API]
    end
    
    subgraph "API Options"
        NoSQL[NoSQL API<br/>Native JSON, SQL-like queries]
        MongoDB[MongoDB API<br/>MongoDB compatibility]
        Cassandra[Cassandra API<br/>CQL queries]
        Gremlin[Gremlin API<br/>Graph database]
        Table[Table API<br/>Key-value pairs]
    end
    
    Account -->|Choose at creation| NoSQL
    Account -->|Choose at creation| MongoDB
    Account -->|Choose at creation| Cassandra
    Account -->|Choose at creation| Gremlin
    Account -->|Choose at creation| Table
    
    Note[Cannot change API after creation]
```

## Stored Procedures & Triggers

```mermaid
graph LR
    subgraph "Server-Side Programming"
        SP[Stored Procedures<br/>Transactional operations<br/>Single partition]
        
        PreTrigger[Pre-Triggers<br/>Before create/update/delete<br/>Validation]
        
        PostTrigger[Post-Triggers<br/>After create/update/delete<br/>Side effects]
        
        UDF[User-Defined Functions<br/>Query projections<br/>Read-only]
    end
    
    subgraph "Execution Context"
        Transaction[ACID Transaction<br/>Within partition]
    end
    
    SP --> Transaction
    PreTrigger --> Transaction
    PostTrigger --> Transaction
```

## Time to Live (TTL)

```mermaid
graph TB
    subgraph "TTL Configuration"
        Container[Container Level<br/>Default TTL]
        Item[Item Level<br/>Override TTL]
    end
    
    subgraph "TTL Values"
        Off[null or undefined<br/>TTL disabled]
        NoExpire[-1<br/>Never expire]
        Seconds[Positive number<br/>Expire after N seconds]
    end
    
    subgraph "Process"
        Background[Background Process]
        Delete[Delete expired items]
        NoCharge[No RU charge]
    end
    
    Container --> Off & NoExpire & Seconds
    Item --> Off & NoExpire & Seconds
    Seconds --> Background
    Background --> Delete
    Delete --> NoCharge
```

## Backup and Restore

```mermaid
graph TB
    subgraph "Backup Modes"
        Periodic[Periodic Backup<br/>Default: Every 4 hours<br/>Retention: 30 days]
        
        Continuous[Continuous Backup<br/>Point-in-time restore<br/>Retention: 7-30 days]
    end
    
    subgraph "Restore Options"
        SameAccount[Same Account<br/>Restore container]
        
        DiffAccount[Different Account<br/>Full restore]
        
        PITR[Point-in-Time<br/>Specific timestamp]
    end
    
    Periodic --> SameAccount & DiffAccount
    Continuous --> PITR
    PITR --> SameAccount & DiffAccount
```

## Security Features

```mermaid
graph TB
    subgraph "Authentication"
        PrimaryKey[Primary Key<br/>Full access]
        ResourceToken[Resource Token<br/>Limited access]
        ManagedID[Managed Identity<br/>Azure AD]
        RBAC[Role-Based Access<br/>Granular permissions]
    end
    
    subgraph "Network Security"
        Firewall[IP Firewall<br/>Allowed IPs]
        VNet[VNet Integration<br/>Service Endpoint]
        PrivateEndpoint[Private Endpoint<br/>Private Link]
    end
    
    subgraph "Data Protection"
        Encryption[Encryption at Rest<br/>Automatic]
        TLS[TLS Encryption<br/>In transit]
        CMK[Customer-Managed Keys<br/>Optional]
    end
    
    PrimaryKey & ResourceToken & ManagedID & RBAC -.Authenticate.-> Access[Access Control]
    Firewall & VNet & PrivateEndpoint -.Protect.-> Network[Network Layer]
    Encryption & TLS & CMK -.Secure.-> Data[Data Layer]
```

## SDK Operations

```mermaid
graph LR
    subgraph "CRUD Operations"
        Create[Create Item<br/>POST /<br/>5 RUs per KB]
        
        Read[Read Item<br/>GET /id<br/>1 RU per KB]
        
        Update[Update Item<br/>PATCH/PUT<br/>~5 RUs per KB]
        
        Delete[Delete Item<br/>DELETE /id<br/>~5 RUs per KB]
    end
    
    subgraph "Query Operations"
        Query[Query Items<br/>SELECT *<br/>Variable RUs]
        
        ReadAll[Read All<br/>List all items<br/>High RU cost]
    end
    
    subgraph "Batch Operations"
        Batch[Transactional Batch<br/>Same partition<br/>ACID guarantee]
        
        Bulk[Bulk Operations<br/>High throughput<br/>Multiple partitions]
    end
```

## Key Concepts Summary

### Global Distribution
- **Multi-Region**: Add/remove regions anytime
- **Replication**: Automatic multi-master replication
- **Failover**: Automatic or manual failover
- **SLA**: 99.999% availability for multi-region

### Consistency Levels
- **Strong**: Linearizability guarantee
- **Bounded Staleness**: Lag by K versions or T time
- **Session**: Read-your-writes (default)
- **Consistent Prefix**: No out-of-order reads
- **Eventual**: Lowest latency, eventual convergence

### Partitioning
- **Logical Partition**: Max 20 GB per partition key value
- **Physical Partition**: Max 10,000 RU/s and 50 GB
- **Partition Key**: Cannot be changed after container creation
- **Hot Partitions**: Avoid with good partition key design

### Request Units
- **Read**: 1 RU per 1 KB (point read)
- **Write**: ~5 RUs per 1 KB
- **Query**: Variable based on complexity
- **Factors**: Item size, indexing, consistency level

### Throughput Modes
- **Provisioned**: Fixed RU/s, hourly billing
- **Autoscale**: Auto-scale between min/max
- **Serverless**: Pay-per-request, 5000 RU/s max

### Change Feed
- **Ordered**: Changes in order per partition key
- **Persistent**: All changes retained
- **Push Model**: Processors push to consumers
- **Use Cases**: Event sourcing, cache invalidation, search index

### Best Practices
1. **Choose partition key carefully** - high cardinality, even distribution
2. **Use point reads** when possible (ID + partition key)
3. **Avoid cross-partition queries** - use partition key in WHERE
4. **Tune indexing policy** - exclude unused paths
5. **Use session consistency** for most scenarios
6. **Implement retry logic** with exponential backoff
7. **Use bulk operations** for high-throughput scenarios
8. **Monitor RU consumption** and optimize queries
9. **Use TTL** to auto-delete expired data
10. **Enable continuous backup** for critical data
