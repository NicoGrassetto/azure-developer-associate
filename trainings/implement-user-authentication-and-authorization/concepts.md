# Authentication & Authorization - Concepts Cheatsheet

## Overview
Microsoft identity platform provides authentication and authorization services using Microsoft Entra ID (formerly Azure AD), OAuth 2.0, OpenID Connect, and Shared Access Signatures for Azure Storage.

## Microsoft Identity Platform Architecture

```mermaid
graph TB
    subgraph "Microsoft Identity Platform"
        EntraID[Microsoft Entra ID<br/>Identity Provider]
        
        subgraph "Protocols"
            OAuth[OAuth 2.0<br/>Authorization]
            OIDC[OpenID Connect<br/>Authentication]
            SAML[SAML 2.0<br/>Enterprise SSO]
        end
        
        subgraph "Libraries"
            MSAL[MSAL<br/>Microsoft Authentication Library]
            IdentitySDK[Azure Identity SDK]
        end
    end
    
    subgraph "Applications"
        Web[Web Apps]
        SPA[Single Page Apps]
        Mobile[Mobile Apps]
        Daemon[Daemon/Service Apps]
    end
    
    EntraID --> OAuth & OIDC & SAML
    OAuth & OIDC --> MSAL & IdentitySDK
    MSAL & IdentitySDK --> Web & SPA & Mobile & Daemon
```

## OAuth 2.0 Flow Types

```mermaid
graph TB
    subgraph "OAuth 2.0 Flows"
        AuthCode[Authorization Code Flow<br/>Web apps with backend<br/>Most secure<br/>Refresh tokens]
        
        PKCE[Auth Code + PKCE<br/>Mobile & SPAs<br/>Public clients<br/>No client secret]
        
        Implicit[Implicit Flow<br/>DEPRECATED<br/>SPAs (legacy)<br/>Tokens in URL]
        
        ClientCreds[Client Credentials<br/>Service-to-service<br/>No user context<br/>App identity]
        
        OnBehalfOf[On-Behalf-Of<br/>Middle tier calls API<br/>User context preserved<br/>Token exchange]
        
        DeviceCode[Device Code Flow<br/>Input-constrained devices<br/>TV, IoT<br/>Browser on phone]
    end
    
    AuthCode -.Best for.-> WebApp[Web Applications]
    PKCE -.Best for.-> SPAMobile[SPAs & Mobile]
    ClientCreds -.Best for.-> Daemon[Background Services]
```

## Authorization Code Flow

```mermaid
sequenceDiagram
    participant User
    participant App as Web Application
    participant Browser
    participant EntraID as Microsoft Entra ID
    participant API as Protected API
    
    User->>App: Access protected resource
    App->>Browser: Redirect to login
    Browser->>EntraID: Authorization request
    EntraID->>User: Login prompt
    User->>EntraID: Enter credentials
    EntraID->>EntraID: Authenticate user
    EntraID->>Browser: Redirect with auth code
    Browser->>App: Auth code
    App->>EntraID: Exchange code for tokens<br/>(+ client secret)
    EntraID-->>App: Access token + Refresh token
    App->>API: Request with access token
    API-->>App: Protected resource
    App-->>User: Display resource
```

## Client Credentials Flow

```mermaid
sequenceDiagram
    participant Service as Background Service
    participant EntraID as Microsoft Entra ID
    participant API as Protected API
    
    Service->>EntraID: Request token<br/>(client ID + secret)
    EntraID->>EntraID: Validate credentials
    EntraID-->>Service: Access token<br/>(no refresh token)
    Service->>API: Request with token
    API->>API: Validate token
    API-->>Service: Protected data
    
    Note over Service,API: No user context
```

## Token Types

```mermaid
graph TB
    subgraph "Token Types"
        AccessToken[Access Token<br/>Short-lived 60-90 min<br/>Access resources<br/>JWT format]
        
        RefreshToken[Refresh Token<br/>Long-lived days/months<br/>Get new access tokens<br/>Opaque to client]
        
        IDToken[ID Token<br/>User identity info<br/>Claims about user<br/>JWT format<br/>OpenID Connect]
    end
    
    subgraph "Usage"
        AccessAPI[Call APIs<br/>Bearer token]
        GetNewToken[Refresh access<br/>Without re-login]
        UserInfo[Display user info<br/>Name, email]
    end
    
    AccessToken --> AccessAPI
    RefreshToken --> GetNewToken
    IDToken --> UserInfo
```

## JWT Token Structure

```mermaid
graph LR
    subgraph "JWT Token"
        Header[Header<br/>Algorithm: RS256<br/>Type: JWT]
        
        Payload[Payload Claims<br/>aud: audience<br/>iss: issuer<br/>exp: expiration<br/>sub: subject<br/>roles: [roles]]
        
        Signature[Signature<br/>Verify integrity<br/>HMAC/RSA]
    end
    
    Header -->|Base64| Encoded1[eyJ...]
    Payload -->|Base64| Encoded2[eyJ...]
    Signature -->|Encoded| Encoded3[SflK...]
    
    Encoded1 & Encoded2 & Encoded3 -->|Join with .| JWT[eyJ....eyJ....SflK]
```

## App Registration Components

```mermaid
graph TB
    subgraph "App Registration"
        AppReg[Application Registration<br/>Microsoft Entra ID]
        
        subgraph "Configuration"
            ClientID[Client ID<br/>Public identifier]
            Secret[Client Secret<br/>Application password]
            RedirectURI[Redirect URIs<br/>Callback URLs]
            APIPerms[API Permissions<br/>Requested scopes]
        end
        
        subgraph "Expose API"
            AppIDURI[Application ID URI<br/>api://app-id]
            Scopes[Scopes<br/>User.Read, Files.Write]
            Roles[App Roles<br/>Admin, Reader]
        end
    end
    
    AppReg --> ClientID & Secret & RedirectURI & APIPerms
    AppReg --> AppIDURI & Scopes & Roles
```

## Permission Types

```mermaid
graph TB
    subgraph "Permission Types"
        Delegated[Delegated Permissions<br/>User + App context<br/>User must consent<br/>Apps with signed-in user]
        
        Application[Application Permissions<br/>App-only context<br/>Admin consent required<br/>Background services]
    end
    
    subgraph "Consent Types"
        User[User Consent<br/>End user approves<br/>Low privilege permissions]
        
        Admin[Admin Consent<br/>Tenant admin approves<br/>High privilege permissions]
    end
    
    Delegated --> User & Admin
    Application --> Admin
```

## MSAL Library Usage

```mermaid
graph TB
    subgraph "MSAL Flow"
        Init[Initialize MSAL Client<br/>Client ID, Authority, Redirect URI]
        
        AcquireToken[Acquire Token]
        
        subgraph "Token Acquisition"
            Silent[Try Silent<br/>From cache]
            Interactive[Interactive<br/>User login]
            Fallback[Fallback logic]
        end
        
        UseToken[Use Access Token<br/>Call API]
    end
    
    Init --> AcquireToken
    AcquireToken --> Silent
    Silent -->|Cache miss| Interactive
    Silent -->|Cache hit| UseToken
    Interactive --> UseToken
```

## Token Caching Strategy

```mermaid
sequenceDiagram
    participant App
    participant MSAL
    participant Cache
    participant EntraID as Microsoft Entra ID
    
    App->>MSAL: Request token
    MSAL->>Cache: Check cache
    
    alt Token in cache & valid
        Cache-->>MSAL: Return cached token
        MSAL-->>App: Access token
    else Token expired & refresh token available
        MSAL->>EntraID: Use refresh token
        EntraID-->>MSAL: New access token
        MSAL->>Cache: Update cache
        MSAL-->>App: New access token
    else No valid token
        MSAL->>EntraID: Interactive login
        EntraID-->>MSAL: Tokens
        MSAL->>Cache: Store tokens
        MSAL-->>App: Access token
    end
```

## Conditional Access Integration

```mermaid
graph TB
    subgraph "Conditional Access Policies"
        Conditions[Conditions<br/>User, Location, Device<br/>Risk level, Platform]
        
        Controls[Access Controls<br/>MFA, Compliant device<br/>Approved app, Terms of use]
    end
    
    subgraph "Authentication Flow"
        Login[User Login Attempt]
        Evaluate[Evaluate Policies]
        Decision{Policy Decision}
        Grant[Grant Access]
        Block[Block Access]
        MFA[Require MFA]
    end
    
    Login --> Evaluate
    Evaluate --> Conditions
    Conditions --> Decision
    Decision -->|Allow| Grant
    Decision -->|Deny| Block
    Decision -->|Challenge| MFA
    MFA -->|Success| Grant
```

## Shared Access Signatures (SAS)

```mermaid
graph TB
    subgraph "SAS Types"
        UserDelegation[User Delegation SAS<br/>Secured with Entra ID<br/>Blob/Container only<br/>Most secure]
        
        Service[Service SAS<br/>Secured with storage key<br/>Single service<br/>Blob, Queue, Table, Files]
        
        Account[Account SAS<br/>Secured with storage key<br/>Multiple services<br/>Account-level operations]
    end
    
    subgraph "SAS Parameters"
        Resource[Resource: Container, Blob]
        Permissions[Permissions: racwdl]
        Time[Start/Expiry time]
        IP[IP restrictions]
        Protocol[Protocol: HTTPS]
    end
    
    UserDelegation & Service & Account --> Resource & Permissions & Time & IP & Protocol
```

## SAS Generation Flow

```mermaid
sequenceDiagram
    participant Client
    participant App as Application
    participant EntraID as Microsoft Entra ID
    participant Storage
    
    Note over Client,Storage: User Delegation SAS
    
    Client->>App: Request access
    App->>EntraID: Authenticate with Managed Identity
    EntraID-->>App: Access token
    App->>Storage: Get user delegation key<br/>(with token)
    Storage-->>App: User delegation key
    App->>App: Generate SAS token<br/>(with delegation key)
    App-->>Client: Return SAS URL
    Client->>Storage: Access resource<br/>(with SAS)
    Storage->>Storage: Validate SAS
    Storage-->>Client: Resource data
```

## SAS Best Practices

```mermaid
graph TB
    subgraph "Security Practices"
        HTTPS[Always use HTTPS<br/>Prevent token interception]
        
        ShortLived[Short expiration times<br/>Minutes to hours]
        
        Minimal[Minimal permissions<br/>Only what's needed]
        
        IPRestrict[IP restrictions<br/>Limit access by IP]
        
        UserDel[Use User Delegation SAS<br/>When possible]
    end
    
    subgraph "Management"
        StoredPolicy[Stored Access Policy<br/>Revoke without regenerating]
        
        Monitor[Monitor usage<br/>Storage Analytics]
        
        Rotate[Rotate storage keys<br/>Invalidate SAS]
    end
    
    HTTPS & ShortLived & Minimal & IPRestrict & UserDel --> Security[Secure SAS]
    StoredPolicy & Monitor & Rotate --> Management[Manage SAS]
```

## Authentication in Web Apps

```mermaid
graph TB
    subgraph "App Service Authentication"
        EasyAuth[Easy Auth / EasyAuth<br/>Built-in authentication]
        
        subgraph "Identity Providers"
            Entra[Microsoft Entra ID]
            Facebook[Facebook]
            Google[Google]
            Twitter[Twitter]
        end
        
        subgraph "Configuration"
            Anonymous[Allow anonymous<br/>No auth required]
            RequireAuth[Require authentication<br/>Redirect to login]
            APIOnly[API-only mode<br/>Return 401]
        end
    end
    
    EasyAuth --> Entra & Facebook & Google & Twitter
    Entra --> Anonymous & RequireAuth & APIOnly
```

## API Protection Patterns

```mermaid
graph TB
    subgraph "Protect API"
        API[Web API]
        
        Validate[Validate JWT Token<br/>Signature, expiration, audience]
        
        Claims[Extract Claims<br/>User ID, roles, scopes]
        
        Authorize[Authorization Check<br/>Role-based, Policy-based]
    end
    
    subgraph "Request Flow"
        Request[Incoming Request<br/>Authorization: Bearer <token>]
        
        Extract[Extract Token]
        
        Decision{Authorized?}
        
        Allow[Process Request<br/>Return 200]
        
        Deny[Reject Request<br/>Return 401/403]
    end
    
    Request --> Extract
    Extract --> Validate
    Validate --> Claims
    Claims --> Authorize
    Authorize --> Decision
    Decision -->|Yes| Allow
    Decision -->|No| Deny
```

## Scopes vs Roles

```mermaid
graph LR
    subgraph "Scopes Delegated"
        Scopes[Scopes<br/>User consent<br/>Delegated permissions<br/>Example: User.Read]
        
        ScopeUse[Used in:<br/>Web apps<br/>Mobile apps<br/>SPAs]
    end
    
    subgraph "Roles Application"
        Roles[App Roles<br/>Admin consent<br/>Application permissions<br/>Example: Files.ReadWrite.All]
        
        RoleUse[Used in:<br/>Daemon apps<br/>Background services<br/>Admin operations]
    end
    
    Scopes --> ScopeUse
    Roles --> RoleUse
```

## Multi-Tenant Applications

```mermaid
graph TB
    subgraph "Tenancy Models"
        Single[Single-Tenant<br/>One organization<br/>Authority: login.microsoftonline.com/{tenant}]
        
        Multi[Multi-Tenant<br/>Any Entra ID org<br/>Authority: login.microsoftonline.com/common]
        
        Personal[Personal Accounts<br/>Microsoft accounts<br/>Authority: login.microsoftonline.com/consumers]
    end
    
    subgraph "Considerations"
        Consent[Admin consent<br/>for each tenant]
        
        Data[Data isolation<br/>per tenant]
        
        Branding[Per-tenant branding<br/>customization]
    end
    
    Multi --> Consent & Data & Branding
```

## Token Validation Steps

```mermaid
graph TB
    subgraph "JWT Token Validation"
        Receive[Receive Token]
        
        Step1[1. Validate Signature<br/>Verify with public key]
        
        Step2[2. Validate Issuer<br/>Check iss claim]
        
        Step3[3. Validate Audience<br/>Check aud claim]
        
        Step4[4. Validate Expiration<br/>Check exp claim]
        
        Step5[5. Validate Scope/Roles<br/>Check permissions]
        
        Accept[Accept Request]
        Reject[Reject: 401 Unauthorized]
    end
    
    Receive --> Step1
    Step1 -->|Valid| Step2
    Step1 -->|Invalid| Reject
    Step2 -->|Valid| Step3
    Step2 -->|Invalid| Reject
    Step3 -->|Valid| Step4
    Step3 -->|Invalid| Reject
    Step4 -->|Valid| Step5
    Step4 -->|Invalid| Reject
    Step5 -->|Valid| Accept
    Step5 -->|Invalid| Reject
```

## Managed Identity with Entra ID

```mermaid
graph TB
    subgraph "Managed Identity Auth"
        App[Application<br/>App Service, Function, VM]
        
        MI[Managed Identity<br/>System or User-assigned]
        
        EntraID[Microsoft Entra ID]
        
        Token[Access Token]
    end
    
    subgraph "Protected Resources"
        KeyVault[Key Vault]
        Storage[Storage Account]
        SQL[SQL Database]
        CosmosDB[Cosmos DB]
        CustomAPI[Custom API]
    end
    
    App --> MI
    MI -->|Request token| EntraID
    EntraID -->|Return token| Token
    Token --> KeyVault & Storage & SQL & CosmosDB & CustomAPI
```

## Key Concepts Summary

### Microsoft Identity Platform
- **Identity Provider**: Microsoft Entra ID (formerly Azure AD)
- **Protocols**: OAuth 2.0, OpenID Connect, SAML 2.0
- **Libraries**: MSAL (Microsoft Authentication Library)
- **Multi-tenant**: Support for multiple organizations

### OAuth 2.0 Flows
- **Authorization Code**: Web apps with backend (most secure)
- **PKCE**: Mobile and SPAs (public clients)
- **Client Credentials**: Service-to-service (no user)
- **On-Behalf-Of**: Middle tier preserves user context

### Token Types
- **Access Token**: Bearer token for API access (1 hour)
- **Refresh Token**: Long-lived, get new access tokens
- **ID Token**: User identity information (OpenID Connect)

### MSAL Features
- **Token Caching**: Automatic caching and refresh
- **Silent Authentication**: Try cache first
- **Interactive Fallback**: User login when needed
- **Account Management**: Multiple account support

### App Registration
- **Client ID**: Public identifier
- **Client Secret**: Confidential apps only
- **Redirect URIs**: Callback URLs after login
- **Permissions**: Delegated and application permissions

### Permissions & Consent
- **Delegated**: User + app context (user consent)
- **Application**: App-only context (admin consent)
- **Scopes**: Granular permissions
- **Roles**: App-level permissions

### Shared Access Signatures (SAS)
- **User Delegation SAS**: Secured with Entra ID (recommended)
- **Service SAS**: Single service access
- **Account SAS**: Multiple services access
- **Parameters**: Permissions, time, IP, protocol

### Token Validation
- **Signature**: Verify with public key
- **Issuer**: Check trusted issuer
- **Audience**: Validate intended recipient
- **Expiration**: Check not expired
- **Claims**: Validate roles/scopes

### Security Best Practices
1. **Use MSAL** instead of raw HTTP requests
2. **Implement token caching** to reduce token requests
3. **Validate all token claims** on API side
4. **Use HTTPS** for all authentication flows
5. **Prefer User Delegation SAS** over account key SAS
6. **Store secrets** in Key Vault, not code
7. **Use Managed Identities** when possible
8. **Implement token refresh** logic
9. **Set short SAS expiration** times
10. **Enable Conditional Access** policies

### Best Practices
1. **Use authorization code flow with PKCE** for SPAs
2. **Never expose client secrets** in public clients
3. **Implement proper error handling** for auth failures
4. **Cache tokens appropriately** based on expiration
5. **Use scopes** to request minimum required permissions
6. **Implement refresh token rotation** for security
7. **Validate JWT tokens** on every API request
8. **Use HTTPS-only** SAS tokens
9. **Monitor authentication** with Azure AD logs
10. **Implement least privilege** access
