# Azure API Management - Concepts Cheatsheet

## Overview
Azure API Management (APIM) is a fully managed service that enables organizations to publish, secure, transform, maintain, and monitor APIs at scale.

## API Management Architecture

```mermaid
graph TB
    subgraph "API Consumers"
        WebApp[Web Applications]
        Mobile[Mobile Apps]
        Partners[Partner Systems]
        Developers[Developers]
    end
    
    subgraph "API Management"
        Gateway[API Gateway<br/>Request routing<br/>Policy enforcement]
        
        Portal[Developer Portal<br/>API documentation<br/>Try-it-out console]
        
        Management[Management Plane<br/>API configuration<br/>Policy management]
    end
    
    subgraph "Backend Services"
        API1[REST API]
        API2[SOAP Service]
        API3[Function App]
        API4[Logic App]
        AzureService[Azure Services]
    end
    
    WebApp & Mobile & Partners & Developers --> Gateway
    Developers --> Portal
    Gateway --> API1 & API2 & API3 & API4 & AzureService
    Management --> Gateway & Portal
```

## API Management Components

```mermaid
graph LR
    subgraph "Core Components"
        Product[Products<br/>API groupings<br/>Subscription required]
        
        API[APIs<br/>Backend endpoints<br/>Operations]
        
        Operations[Operations<br/>HTTP methods<br/>URL patterns]
        
        Policy[Policies<br/>Request/Response<br/>transformations]
    end
    
    subgraph "Access Control"
        Subscription[Subscriptions<br/>API keys<br/>Access control]
        
        Group[Groups<br/>Administrators<br/>Developers<br/>Guests]
    end
    
    Product --> API
    API --> Operations
    Operations --> Policy
    Subscription --> Product
    Group --> Product
```

## Service Tiers

```mermaid
graph TB
    subgraph "APIM Tiers"
        Consumption[Consumption<br/>Serverless<br/>Pay-per-use<br/>Auto-scale]
        
        Developer[Developer<br/>Dev/Test<br/>No SLA<br/>Limited cache]
        
        Basic[Basic<br/>Production<br/>99.95% SLA<br/>Up to 2 units]
        
        Standard[Standard<br/>Production<br/>99.95% SLA<br/>Up to 4 units]
        
        Premium[Premium<br/>Enterprise<br/>99.99% SLA<br/>Multi-region<br/>VNet support]
    end
    
    Developer -.Upgrade.-> Basic
    Basic -.Upgrade.-> Standard
    Standard -.Upgrade.-> Premium
```

## Policy Structure

```mermaid
graph TB
    subgraph "Policy Sections"
        Inbound[Inbound<br/>Before forwarding to backend<br/>Validate, transform, authenticate]
        
        Backend[Backend<br/>Before/after calling backend<br/>Retry, circuit breaker]
        
        Outbound[Outbound<br/>Before returning to client<br/>Transform response, cache]
        
        OnError[On-Error<br/>Error handling<br/>Logging, custom responses]
    end
    
    Request[Client Request] --> Inbound
    Inbound --> Backend
    Backend --> BackendAPI[Backend API]
    BackendAPI --> Backend
    Backend --> Outbound
    Outbound --> Response[Client Response]
    
    Inbound & Backend & Outbound -.Error.-> OnError
```

## Common Policies Flow

```mermaid
sequenceDiagram
    participant Client
    participant Gateway as APIM Gateway
    participant Backend as Backend API
    
    Client->>Gateway: API Request
    
    Note over Gateway: Inbound Policies
    Gateway->>Gateway: Check rate limit
    Gateway->>Gateway: Validate JWT
    Gateway->>Gateway: Transform request
    Gateway->>Gateway: Set backend URL
    
    Note over Gateway: Backend Policies
    Gateway->>Backend: Forward request
    Backend-->>Gateway: Response
    
    alt Backend error
        Gateway->>Gateway: Retry policy
        Gateway->>Backend: Retry request
    end
    
    Note over Gateway: Outbound Policies
    Gateway->>Gateway: Transform response
    Gateway->>Gateway: Set cache headers
    Gateway->>Gateway: Remove headers
    
    Gateway-->>Client: API Response
```

## Authentication Policies

```mermaid
graph TB
    subgraph "Authentication Methods"
        JWT[Validate JWT<br/>Entra ID, OAuth<br/>Verify token signature]
        
        Certificate[Validate Certificate<br/>Client certificates<br/>Mutual TLS]
        
        Basic[Basic Auth<br/>Username/password<br/>Legacy systems]
        
        APIKey[Subscription Key<br/>APIM subscription<br/>Header or query param]
    end
    
    subgraph "Policy Application"
        ProductLevel[Product Level<br/>All APIs in product]
        
        APILevel[API Level<br/>All operations in API]
        
        OperationLevel[Operation Level<br/>Specific operation]
    end
    
    JWT & Certificate & Basic & APIKey --> ProductLevel & APILevel & OperationLevel
```

## Rate Limiting Strategies

```mermaid
graph TB
    subgraph "Rate Limit Policies"
        RateLimit[Rate Limit<br/>Calls per period<br/>Per subscription]
        
        Quota[Quota<br/>Total calls<br/>Per subscription<br/>Per time period]
        
        ConcurrencyLimit[Concurrency Limit<br/>Simultaneous calls<br/>Per subscription]
    end
    
    subgraph "Throttling Behavior"
        Allow[Allow Request]
        Throttle[Return 429<br/>Too Many Requests]
        RetryAfter[Retry-After header<br/>Time to wait]
    end
    
    subgraph "Example"
        Ex1[Rate Limit:<br/>100 calls per minute]
        Ex2[Quota:<br/>10,000 calls per month]
        Ex3[Concurrency:<br/>5 simultaneous calls]
    end
    
    RateLimit --> Allow & Throttle
    Throttle --> RetryAfter
    RateLimit -.Example.-> Ex1
    Quota -.Example.-> Ex2
    ConcurrencyLimit -.Example.-> Ex3
```

## Subscription Keys

```mermaid
graph TB
    subgraph "Subscription Tiers"
        Product[Product Subscription<br/>Access to all APIs in product<br/>Primary + Secondary key]
        
        AllAPIs[All APIs Subscription<br/>Master key<br/>Access to all products]
    end
    
    subgraph "Key Management"
        Generate[Generate Keys<br/>Create new keys]
        
        Regenerate[Regenerate Keys<br/>Primary or Secondary]
        
        Revoke[Revoke Subscription<br/>Disable access]
    end
    
    subgraph "Usage"
        Header[HTTP Header<br/>Ocp-Apim-Subscription-Key]
        
        QueryParam[Query Parameter<br/>subscription-key=...]
    end
    
    Product & AllAPIs --> Generate & Regenerate & Revoke
    Product & AllAPIs --> Header & QueryParam
```

## Caching Strategy

```mermaid
sequenceDiagram
    participant Client
    participant Gateway as APIM Gateway
    participant Cache
    participant Backend
    
    Client->>Gateway: API Request
    Gateway->>Cache: Check cache
    
    alt Cache hit
        Cache-->>Gateway: Cached response
        Gateway-->>Client: Return cached response
    else Cache miss
        Gateway->>Backend: Forward request
        Backend-->>Gateway: Response
        Gateway->>Cache: Store in cache
        Gateway-->>Client: Return response
    end
    
    Note over Cache: Cache duration based on policy
```

## Caching Policies

```mermaid
graph TB
    subgraph "Cache Policies"
        StoreCache[cache-store<br/>Store response in cache<br/>Duration, vary-by parameters]
        
        LookupCache[cache-lookup<br/>Check cache before backend<br/>Vary-by keys]
        
        RemoveCache[cache-remove-value<br/>Invalidate cached entries]
    end
    
    subgraph "Cache Keys"
        VaryByHeader[Vary by Header<br/>Different cache per header]
        
        VaryByQuery[Vary by Query Param<br/>Different cache per param]
        
        VaryBySubscription[Vary by Subscription<br/>Per-user caching]
    end
    
    LookupCache --> StoreCache
    StoreCache --> VaryByHeader & VaryByQuery & VaryBySubscription
```

## Transformation Policies

```mermaid
graph LR
    subgraph "Request Transformations"
        SetMethod[Set HTTP Method<br/>GET → POST]
        
        SetHeader[Set Headers<br/>Add, modify, remove]
        
        SetQuery[Set Query Parameters<br/>Add, modify, remove]
        
        SetBody[Set Body<br/>Transform payload]
        
        ConvertXML[Convert XML ↔ JSON<br/>Format transformation]
    end
    
    subgraph "Response Transformations"
        FilterResponse[Filter Response<br/>Remove sensitive fields]
        
        TransformJSON[Transform JSON<br/>Restructure data]
        
        AddCORS[Add CORS Headers<br/>Cross-origin support]
    end
    
    Request[Client Request] --> SetMethod & SetHeader & SetQuery & SetBody & ConvertXML
    FilterResponse & TransformJSON & AddCORS --> Response[Client Response]
```

## Named Values & Backends

```mermaid
graph TB
    subgraph "Named Values"
        NV[Named Values<br/>Key-value pairs<br/>Configuration settings]
        
        subgraph "Types"
            Plain[Plain Text<br/>Non-sensitive]
            Secret[Secret<br/>Encrypted values]
            KeyVault[Key Vault<br/>Reference secrets]
        end
        
        Usage[Use in Policies<br/>{{named-value-key}}]
    end
    
    subgraph "Backends"
        Backend[Backend Entity<br/>Centralized backend config<br/>URL, authentication]
        
        BackendPolicy[set-backend-service<br/>Route to specific backend]
    end
    
    NV --> Plain & Secret & KeyVault
    Plain & Secret & KeyVault --> Usage
    Usage --> BackendPolicy
```

## Developer Portal

```mermaid
graph TB
    subgraph "Developer Portal Features"
        Docs[API Documentation<br/>Auto-generated<br/>OpenAPI/Swagger]
        
        Console[Interactive Console<br/>Try API calls<br/>Real-time testing]
        
        Subscription[Self-service<br/>Request API access<br/>Manage subscriptions]
        
        Customize[Customization<br/>Branding<br/>Custom pages]
    end
    
    subgraph "Developer Experience"
        Dev[Developer]
        
        Browse[Browse APIs]
        Test[Test APIs]
        GetKey[Get API Keys]
        Monitor[Monitor Usage]
    end
    
    Dev --> Browse & Test & GetKey & Monitor
    Browse --> Docs
    Test --> Console
    GetKey --> Subscription
```

## Products and Groups

```mermaid
graph TB
    subgraph "Products"
        Starter[Starter Product<br/>5 calls/min<br/>Free tier]
        
        Premium[Premium Product<br/>Unlimited calls<br/>Paid tier]
        
        Internal[Internal Product<br/>Internal APIs<br/>Restricted access]
    end
    
    subgraph "Groups"
        Admins[Administrators<br/>Full access<br/>Manage APIM]
        
        Developers[Developers<br/>Developer portal access<br/>Subscribe to products]
        
        Guests[Guests<br/>Read-only access<br/>View APIs]
        
        CustomGroup[Custom Groups<br/>Custom access control]
    end
    
    Starter & Premium & Internal --> Admins
    Starter & Premium --> Developers
    Starter --> Guests
    Internal --> CustomGroup
```

## API Versioning Strategies

```mermaid
graph TB
    subgraph "Versioning Schemes"
        Path[Path-based<br/>api.com/v1/products<br/>api.com/v2/products]
        
        Query[Query Parameter<br/>api.com/products?version=1<br/>api.com/products?version=2]
        
        Header[Header-based<br/>api-version: 1<br/>api-version: 2]
    end
    
    subgraph "API Versions"
        V1[Version 1<br/>Legacy endpoints]
        V2[Version 2<br/>Current endpoints]
        V3[Version 3<br/>Beta endpoints]
    end
    
    Path & Query & Header --> V1 & V2 & V3
```

## Revisions vs Versions

```mermaid
graph LR
    subgraph "Revisions"
        Rev[Revisions<br/>Non-breaking changes<br/>Same API version<br/>Switch revisions]
        
        RevUse[Use for:<br/>Backend changes<br/>Policy updates<br/>A/B testing]
    end
    
    subgraph "Versions"
        Ver[Versions<br/>Breaking changes<br/>Different API version<br/>Side-by-side]
        
        VerUse[Use for:<br/>API contract changes<br/>Major updates<br/>Migration periods]
    end
    
    Rev --> RevUse
    Ver --> VerUse
```

## Virtual Network Integration

```mermaid
graph TB
    subgraph "VNet Modes"
        External[External VNet<br/>Public gateway endpoint<br/>Backend in VNet]
        
        Internal[Internal VNet<br/>Private gateway endpoint<br/>Backend in VNet<br/>No public access]
    end
    
    subgraph "Connectivity"
        Internet[Internet Clients]
        VNet[Virtual Network]
        OnPrem[On-Premises]
        Backend[Backend Services]
    end
    
    Internet --> External
    External --> Backend
    VNet --> Internal
    OnPrem --> Internal
    Internal --> Backend
    
    External & Internal -.Located in.-> VNet
```

## Monitoring and Analytics

```mermaid
graph TB
    subgraph "APIM Monitoring"
        Metrics[Azure Metrics<br/>Requests, capacity<br/>Response time]
        
        Logs[Diagnostic Logs<br/>Request/response logs<br/>Errors, warnings]
        
        Analytics[Built-in Analytics<br/>API usage<br/>Performance]
    end
    
    subgraph "Integration"
        AppInsights[Application Insights<br/>Detailed telemetry<br/>Dependencies, failures]
        
        LogAnalytics[Log Analytics<br/>Query and analyze<br/>Custom dashboards]
        
        EventHub[Event Hub<br/>Stream logs<br/>Real-time processing]
    end
    
    Metrics & Logs & Analytics --> AppInsights & LogAnalytics & EventHub
```

## Circuit Breaker Pattern

```mermaid
stateDiagram-v2
    [*] --> Closed
    Closed --> Open: Failure threshold reached
    Open --> HalfOpen: Timeout expired
    HalfOpen --> Closed: Success
    HalfOpen --> Open: Failure
    
    note right of Closed
        Normal operation
        Forward requests
    end note
    
    note right of Open
        Block requests
        Return error immediately
        Wait timeout period
    end note
    
    note right of HalfOpen
        Test with limited requests
        Check if backend recovered
    end note
```

## Retry Policy

```mermaid
sequenceDiagram
    participant Gateway as APIM Gateway
    participant Backend
    
    Gateway->>Backend: Request (Attempt 1)
    Backend-->>Gateway: 500 Internal Server Error
    
    Note over Gateway: Wait: exponential backoff
    
    Gateway->>Backend: Request (Attempt 2)
    Backend-->>Gateway: 503 Service Unavailable
    
    Note over Gateway: Wait: exponential backoff
    
    Gateway->>Backend: Request (Attempt 3)
    Backend-->>Gateway: 200 OK
    
    Note over Gateway: Success after retries
```

## Security Features

```mermaid
graph TB
    subgraph "API Security"
        OAuth[OAuth 2.0<br/>Validate JWT tokens<br/>Entra ID integration]
        
        Certificate[Client Certificates<br/>Mutual TLS<br/>Certificate validation]
        
        IP[IP Filtering<br/>Whitelist/Blacklist<br/>IP restrictions]
        
        CORS[CORS Policy<br/>Cross-origin requests<br/>Allowed origins]
    end
    
    subgraph "Advanced Security"
        WAF[Web Application Firewall<br/>OWASP protection<br/>Premium tier]
        
        Throttling[Throttling<br/>Rate limiting<br/>DDoS protection]
        
        VNet[Virtual Network<br/>Network isolation<br/>Private endpoints]
    end
    
    OAuth & Certificate & IP & CORS --> BasicSecurity[API Protection]
    WAF & Throttling & VNet --> AdvancedSecurity[Enterprise Security]
```

## Key Concepts Summary

### Components
- **Products**: Grouping of APIs with terms of use
- **APIs**: Backend service definitions
- **Operations**: HTTP methods and paths
- **Policies**: Request/response processing rules

### Service Tiers
- **Consumption**: Serverless, pay-per-use
- **Developer**: Dev/test, no SLA
- **Basic/Standard**: Production, 99.95% SLA
- **Premium**: Enterprise, 99.99% SLA, multi-region

### Policies
- **Inbound**: Before backend call (auth, transform)
- **Backend**: Before/after backend (retry, circuit breaker)
- **Outbound**: Before client response (transform, cache)
- **On-Error**: Error handling and logging

### Authentication
- **Subscription Keys**: Primary/secondary keys per product
- **JWT Validation**: OAuth 2.0 token validation
- **Client Certificates**: Mutual TLS authentication
- **Basic Auth**: Username/password (legacy)

### Rate Limiting
- **Rate Limit**: Calls per time period
- **Quota**: Total calls per period
- **Concurrency**: Simultaneous calls limit

### Caching
- **Duration**: Time to cache responses
- **Vary-by**: Cache key variations (header, query, subscription)
- **Internal Cache**: In-memory cache in gateway
- **External Cache**: Redis cache for Premium tier

### Versioning
- **Versions**: Breaking changes, side-by-side APIs
- **Revisions**: Non-breaking changes, switchable within version
- **Schemes**: Path, query parameter, header

### Developer Portal
- **Documentation**: Auto-generated API docs
- **Try-it-out**: Interactive API testing
- **Self-service**: Subscribe to products
- **Customization**: Branded portal

### Best Practices
1. **Use subscription keys** for basic API protection
2. **Implement JWT validation** for OAuth 2.0 APIs
3. **Apply rate limiting** to prevent abuse
4. **Cache responses** to reduce backend load
5. **Use named values** for configuration management
6. **Enable CORS** for browser-based clients
7. **Implement retry policies** for resilience
8. **Monitor with Application Insights** for visibility
9. **Use Premium tier** for production multi-region
10. **Version APIs** for backward compatibility
