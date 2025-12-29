# Azure Blob Storage - Concepts Cheatsheet

## Overview
Azure Blob Storage is Microsoft's object storage solution for the cloud, optimized for storing massive amounts of unstructured data like text, binary data, images, videos, and backups.

## Blob Storage Architecture

```mermaid
graph TB
    subgraph "Storage Account"
        Account[Storage Account<br/>Unique namespace]
        
        subgraph "Containers"
            C1[Container 1<br/>photos]
            C2[Container 2<br/>documents]
            C3[Container 3<br/>backups]
        end
        
        subgraph "Blobs"
            B1[Block Blobs<br/>Images, videos, documents]
            B2[Append Blobs<br/>Logs, streaming data]
            B3[Page Blobs<br/>VHD disks]
        end
    end
    
    Account --> C1 & C2 & C3
    C1 & C2 --> B1
    C1 --> B2
    C3 --> B3
```

## Storage Account Tiers

```mermaid
graph LR
    subgraph "Performance Tiers"
        Standard[Standard<br/>HDD-based<br/>Lower cost<br/>General purpose]
        
        Premium[Premium<br/>SSD-based<br/>Low latency<br/>High throughput]
    end
    
    subgraph "Premium Types"
        PremiumBlock[Block Blobs<br/>High transaction rates]
        PremiumPage[Page Blobs<br/>VMs and disks]
        PremiumFiles[File Shares<br/>Enterprise apps]
    end
    
    Standard -.For most workloads.-> Use1[General Use]
    Premium --> PremiumBlock & PremiumPage & PremiumFiles
    PremiumBlock -.For.-> Use2[Analytics, IoT]
```

## Blob Types Comparison

```mermaid
graph TB
    subgraph "Block Blobs"
        BB[Block Blobs<br/>Up to 190.7 TiB<br/>Optimized for upload/download]
        BBUse[Use Cases:<br/>Images, videos<br/>Documents, files<br/>Backups]
        BB --> BBUse
    end
    
    subgraph "Append Blobs"
        AB[Append Blobs<br/>Up to 195 GiB<br/>Optimized for append operations]
        ABUse[Use Cases:<br/>Log files<br/>Streaming data<br/>Audit trails]
        AB --> ABUse
    end
    
    subgraph "Page Blobs"
        PB[Page Blobs<br/>Up to 8 TiB<br/>Optimized for random read/write]
        PBUse[Use Cases:<br/>VHD disks<br/>Azure VMs<br/>Database files]
        PB --> PBUse
    end
```

## Access Tiers

```mermaid
graph TB
    subgraph "Access Tiers"
        Hot[Hot Tier<br/>Highest storage cost<br/>Lowest access cost<br/>Frequent access]
        
        Cool[Cool Tier<br/>Lower storage cost<br/>Higher access cost<br/>Min 30 days<br/>Infrequent access]
        
        Cold[Cold Tier<br/>Even lower storage cost<br/>Even higher access cost<br/>Min 90 days<br/>Rarely accessed]
        
        Archive[Archive Tier<br/>Lowest storage cost<br/>Highest access cost<br/>Min 180 days<br/>Offline storage]
    end
    
    Hot -->|Less access| Cool
    Cool -->|Less access| Cold
    Cold -->|Rarely access| Archive
    
    Hot -.Rehydration Time.-> Time1[Immediate]
    Cool -.Rehydration Time.-> Time2[Immediate]
    Cold -.Rehydration Time.-> Time3[Immediate]
    Archive -.Rehydration Time.-> Time4[Hours<br/>Standard: < 15hr<br/>High Priority: < 1hr]
```

## Lifecycle Management

```mermaid
graph LR
    subgraph "Blob Lifecycle"
        Upload[Upload Blob<br/>Hot Tier]
        
        Move1[After 30 days<br/>Move to Cool]
        
        Move2[After 90 days<br/>Move to Cold]
        
        Move3[After 180 days<br/>Move to Archive]
        
        Delete[After 365 days<br/>Delete Blob]
    end
    
    Upload --> Move1 --> Move2 --> Move3 --> Delete
    
    Policy[Lifecycle Policy<br/>JSON rules<br/>Automatic execution]
    Policy -.Automates.-> Upload
```

## Lifecycle Policy Example

```mermaid
graph TB
    subgraph "Policy Rules"
        Rule1[Rule 1: Base Blobs<br/>If not modified for 30 days<br/>→ Move to Cool]
        
        Rule2[Rule 2: Base Blobs<br/>If not modified for 90 days<br/>→ Move to Archive]
        
        Rule3[Rule 3: Snapshots<br/>If created > 90 days ago<br/>→ Delete]
        
        Rule4[Rule 4: Versions<br/>If created > 180 days ago<br/>→ Delete]
    end
    
    subgraph "Filters"
        Filter1[Prefix Filter<br/>logs/*]
        Filter2[Blob Type<br/>blockBlob]
    end
    
    Filter1 & Filter2 --> Rule1 & Rule2 & Rule3 & Rule4
```

## Blob Versioning & Snapshots

```mermaid
graph TB
    subgraph "Blob Versions"
        Current[Current Version<br/>v3 (latest)]
        V2[Previous Version<br/>v2]
        V1[Previous Version<br/>v1]
        
        Current -.Modify.-> NewVersion[New Current v4]
        NewVersion -.Demotes.-> Current
    end
    
    subgraph "Blob Snapshots"
        Base[Base Blob<br/>Original]
        Snap1[Snapshot 1<br/>Point-in-time copy]
        Snap2[Snapshot 2<br/>Point-in-time copy]
        
        Base -.Create snapshot.-> Snap1
        Base -.Create snapshot.-> Snap2
    end
    
    Note1[Versions: Automatic<br/>on overwrites]
    Note2[Snapshots: Manual<br/>on demand]
```

## Soft Delete

```mermaid
sequenceDiagram
    participant User
    participant Blob as Blob Storage
    participant SoftDelete as Soft Delete Container
    participant Permanent as Permanent Delete
    
    User->>Blob: Delete blob
    Blob->>SoftDelete: Move to soft delete
    Note over SoftDelete: Retention period<br/>(1-365 days)
    
    alt Restore within retention
        User->>SoftDelete: Restore blob
        SoftDelete->>Blob: Blob restored
    else Retention expires
        SoftDelete->>Permanent: Permanently delete
    end
```

## Security & Access Control

```mermaid
graph TB
    subgraph "Authentication Methods"
        AAD[Microsoft Entra ID<br/>RBAC roles<br/>Recommended]
        
        SharedKey[Shared Key<br/>Account keys<br/>Full access]
        
        SAS[Shared Access Signature<br/>Delegated access<br/>Time-limited]
        
        Anonymous[Anonymous<br/>Public read access<br/>Container or blob level]
    end
    
    subgraph "Access Levels"
        Private[Private<br/>No anonymous access]
        Blob[Blob<br/>Public read for blobs only]
        Container[Container<br/>Public read for blobs and list]
    end
    
    AAD & SharedKey & SAS & Anonymous --> Private & Blob & Container
```

## Shared Access Signature (SAS)

```mermaid
graph TB
    subgraph "SAS Types"
        UserSAS[User Delegation SAS<br/>Secured with Entra ID<br/>Blob/Container only<br/>Recommended]
        
        ServiceSAS[Service SAS<br/>Secured with storage key<br/>One service only]
        
        AccountSAS[Account SAS<br/>Secured with storage key<br/>Multiple services]
    end
    
    subgraph "SAS Parameters"
        Permissions[Permissions<br/>Read, Write, Delete, List]
        Time[Start/End Time<br/>Validity period]
        IP[IP Restrictions<br/>Allowed IPs]
        Protocol[Protocol<br/>HTTPS only]
    end
    
    UserSAS & ServiceSAS & AccountSAS --> Permissions & Time & IP & Protocol
```

## Data Transfer Methods

```mermaid
graph TB
    subgraph "Upload Methods"
        Portal[Azure Portal<br/>Small files, GUI]
        
        CLI[Azure CLI/PowerShell<br/>Scripting, automation]
        
        SDK[Azure SDK<br/>Python, .NET, Java, Node.js]
        
        AzCopy[AzCopy<br/>Command-line, bulk transfer]
        
        DataBox[Azure Data Box<br/>Physical device, TB-PB scale]
    end
    
    subgraph "Scenarios"
        Small[< 1 GB<br/>Few files]
        Medium[1-100 GB<br/>Regular transfers]
        Large[100 GB - 1 TB<br/>Bulk migration]
        Massive[> 1 TB<br/>Offline transfer]
    end
    
    Portal --> Small
    CLI & SDK --> Medium
    AzCopy --> Large
    DataBox --> Massive
```

## Blob Operations Workflow

```mermaid
sequenceDiagram
    participant App as Application
    participant SDK as Azure SDK
    participant Storage as Blob Storage
    participant Container as Container
    
    App->>SDK: Create BlobServiceClient
    SDK->>Storage: Authenticate
    Storage-->>SDK: Connection established
    
    App->>SDK: GetContainerClient("mycontainer")
    SDK->>Container: Access container
    
    App->>SDK: Upload blob
    SDK->>Container: Upload data in blocks
    Container-->>SDK: Upload complete
    SDK-->>App: Blob URI returned
    
    App->>SDK: Download blob
    SDK->>Container: Request blob
    Container-->>SDK: Stream data
    SDK-->>App: Downloaded content
```

## Block Blob Upload Strategies

```mermaid
graph TB
    subgraph "Upload Strategies"
        Small[Small Files < 256 MB<br/>Single PUT operation]
        
        Large[Large Files > 256 MB<br/>Upload in blocks<br/>Then commit block list]
        
        Parallel[Parallel Upload<br/>Multiple blocks simultaneously<br/>Higher throughput]
    end
    
    subgraph "Process"
        Block1[Block 1] & Block2[Block 2] & Block3[Block 3]
        Commit[Commit Block List]
        Complete[Complete Blob]
    end
    
    Large --> Block1 & Block2 & Block3
    Parallel --> Block1 & Block2 & Block3
    Block1 & Block2 & Block3 --> Commit
    Commit --> Complete
```

## Blob Indexing & Metadata

```mermaid
graph TB
    subgraph "Blob Properties"
        System[System Properties<br/>Content-Type, Content-Length<br/>ETag, Last-Modified]
        
        Metadata[User-Defined Metadata<br/>Key-value pairs<br/>Max 8 KB<br/>Custom tags]
        
        Index[Blob Index Tags<br/>Searchable tags<br/>Max 10 tags<br/>Query across blobs]
    end
    
    subgraph "Use Cases"
        Filter[Filter by tags<br/>SELECT * WHERE tags.env='prod']
        
        Organize[Organize data<br/>project=alpha, env=dev]
        
        Lifecycle[Lifecycle rules<br/>Based on tags]
    end
    
    Index --> Filter & Organize & Lifecycle
```

## Storage Redundancy Options

```mermaid
graph TB
    subgraph "Redundancy Options"
        LRS[LRS<br/>Locally Redundant<br/>3 copies in 1 datacenter<br/>11 nines durability]
        
        ZRS[ZRS<br/>Zone Redundant<br/>3 copies across 3 zones<br/>12 nines durability]
        
        GRS[GRS<br/>Geo Redundant<br/>LRS + async copy to secondary region<br/>16 nines durability]
        
        GZRS[GZRS<br/>Geo-Zone Redundant<br/>ZRS + async copy to secondary region<br/>16 nines durability]
        
        RA-GRS[RA-GRS<br/>Read-Access GRS<br/>GRS + read from secondary]
        
        RA-GZRS[RA-GZRS<br/>Read-Access GZRS<br/>GZRS + read from secondary]
    end
    
    LRS -->|Add zone redundancy| ZRS
    LRS -->|Add geo redundancy| GRS
    ZRS -->|Add geo redundancy| GZRS
    GRS -->|Add read access| RA-GRS
    GZRS -->|Add read access| RA-GZRS
```

## Change Feed

```mermaid
sequenceDiagram
    participant Blob as Blob Storage
    participant CF as Change Feed
    participant Processor as Processor
    participant App as Application
    
    Note over Blob: Create/Update/Delete blob
    Blob->>CF: Log change event
    CF->>CF: Store in $blobchangefeed
    
    Processor->>CF: Query changes
    CF-->>Processor: Return events
    Processor->>App: Process event
    App->>App: Execute logic
    
    Note over Processor: Continue from cursor
```

## Static Website Hosting

```mermaid
graph LR
    subgraph "Storage Account"
        Container[Container: $web]
        
        subgraph "Files"
            HTML[index.html]
            CSS[styles.css]
            JS[app.js]
            Images[images/*]
        end
    end
    
    subgraph "CDN (Optional)"
        CDN[Azure CDN<br/>Global distribution<br/>Custom domain<br/>SSL/TLS]
    end
    
    Users[Users] -->|HTTP/HTTPS| CDN
    CDN -->|Cache miss| Container
    Container --> HTML & CSS & JS & Images
```

## Blob Leasing

```mermaid
sequenceDiagram
    participant Client1
    participant Client2
    participant Blob
    
    Client1->>Blob: Acquire lease
    Blob-->>Client1: Lease ID
    Note over Client1,Blob: Exclusive lock (15-60 sec or infinite)
    
    Client2->>Blob: Try to modify
    Blob-->>Client2: 412 Precondition Failed
    
    Client1->>Blob: Modify blob (with lease ID)
    Blob-->>Client1: Success
    
    Client1->>Blob: Release lease
    Blob-->>Client1: Lease released
    
    Client2->>Blob: Modify blob
    Blob-->>Client2: Success
```

## Encryption & Security

```mermaid
graph TB
    subgraph "Encryption at Rest"
        SSE[Storage Service Encryption<br/>Automatic, transparent<br/>256-bit AES]
        
        subgraph "Key Management"
            Microsoft[Microsoft-Managed Keys<br/>Default, automatic]
            Customer[Customer-Managed Keys<br/>Key Vault integration]
        end
    end
    
    subgraph "Encryption in Transit"
        HTTPS[HTTPS/TLS<br/>Required for SAS]
        SecureTransfer[Require secure transfer<br/>Storage account setting]
    end
    
    subgraph "Client-Side Encryption"
        ClientEnc[Encrypt before upload<br/>Decrypt after download<br/>Application controlled]
    end
    
    SSE --> Microsoft & Customer
    HTTPS --> SecureTransfer
```

## Performance Optimization

```mermaid
graph TB
    subgraph "Optimization Strategies"
        Concurrent[Concurrent Operations<br/>Upload/download in parallel]
        
        BlockSize[Optimal Block Size<br/>4-100 MB per block]
        
        CDN[Use Azure CDN<br/>Cache frequently accessed content]
        
        Premium[Premium Storage<br/>SSD-based, low latency]
        
        Compression[Compress data<br/>Before upload]
    end
    
    subgraph "Monitoring"
        Metrics[Storage Metrics<br/>Transactions, latency]
        
        Analytics[Storage Analytics<br/>Detailed logs]
        
        AppInsights[Application Insights<br/>End-to-end monitoring]
    end
    
    Concurrent & BlockSize & CDN & Premium & Compression -.Improve.-> Performance[Performance]
    Metrics & Analytics & AppInsights -.Monitor.-> Performance
```

## Key Concepts Summary

### Storage Account Types
- **General Purpose v2**: Most scenarios, all services
- **Premium Block Blobs**: High transaction rates, low latency
- **Premium Page Blobs**: VMs and disks
- **Blob Storage**: Legacy, use GPv2 instead

### Blob Types
- **Block Blobs**: General purpose, up to 190.7 TiB
- **Append Blobs**: Append operations, logs, up to 195 GiB
- **Page Blobs**: Random read/write, VHDs, up to 8 TiB

### Access Tiers
- **Hot**: Frequent access, highest storage cost
- **Cool**: Infrequent access, 30-day minimum
- **Cold**: Rare access, 90-day minimum  
- **Archive**: Offline storage, 180-day minimum, hours to rehydrate

### Security Features
- **Entra ID (RBAC)**: Recommended authentication
- **Shared Access Signature**: Delegated access with constraints
- **Account Keys**: Full access, rotate regularly
- **Encryption**: Automatic at rest, TLS in transit

### Data Protection
- **Soft Delete**: Recover deleted blobs (1-365 days)
- **Versioning**: Automatic version tracking
- **Snapshots**: Point-in-time copies
- **Immutable Storage**: WORM compliance

### Lifecycle Management
- **Automatic Tiering**: Move blobs between tiers
- **Automatic Deletion**: Delete old blobs
- **Filters**: Prefix, blob type, tags
- **Actions**: Tier, delete, based on age

### Redundancy
- **LRS**: 3 copies, 1 datacenter
- **ZRS**: 3 copies, 3 zones
- **GRS/RA-GRS**: Geo-redundant with optional read access
- **GZRS/RA-GZRS**: Zone + Geo redundant

### Best Practices
1. **Use Microsoft Entra ID** for authentication instead of account keys
2. **Enable soft delete** to protect against accidental deletion
3. **Use lifecycle policies** to automatically manage blob tiers
4. **Implement SAS** with minimal permissions and expiration
5. **Enable versioning** for critical data
6. **Use Premium storage** for low-latency requirements
7. **Upload large files in blocks** with parallelism
8. **Enable blob index tags** for searchable metadata
9. **Use Azure CDN** for frequently accessed public content
10. **Monitor with Storage Analytics** and set up alerts
