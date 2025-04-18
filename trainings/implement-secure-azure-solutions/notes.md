## Implement authentication by using the Microsoft Authentication Library

### Introduction

The Microsoft Authentication Library (MSAL) enables developers to acquire tokens from the Microsoft identity platform in order to authenticate users and access secured web APIs.

### Explore the Microsoft Authentication Library

The Microsoft Authentication Library (MSAL) enables developers to acquire security tokens from the Microsoft identity platform to authenticate users and access secured web APIs. It can be used to provide secure access to Microsoft Graph, other Microsoft APIs, third-party web APIs, or your own web API MSAL supports many different application architectures and platforms including .NET, JavaScript, Java, Python, Android, and iOS.

MSAL gives you many ways to get tokens, with a consistent API for many platforms. Using MSAL provides the following benefits:

- No need to directly use the OAuth libraries or code against the protocol in your application.
- Acquires tokens on behalf of a user or on behalf of an application (when applicable to the platform).
- Maintains a token cache and refreshes tokens for you when they're close to expire. You don't need to handle token expiration on your own.
- Helps you specify which audience you want your application to sign in.
- Helps you set up your application from configuration files.
- Helps you troubleshoot your app by exposing actionable exceptions, logging, and telemetry.

#### Application types and scenarios

Within MSAL, a token can be acquired from many application types: web applications, web APIs, single-page apps (JavaScript), mobile and native applications, and daemons and server-side applications. MSAL currently supports the platforms and frameworks listed in the following table.

| Library | Supported platforms and frameworks |
|---------|-----------------------------------|
| [MSAL for Android](https://github.com/AzureAD/microsoft-authentication-library-for-android) | Android |
| [MSAL Angular](https://github.com/AzureAD/microsoft-authentication-library-for-js/tree/dev/lib/msal-angular) | Single-page apps with Angular and Angular.js frameworks |  
| [MSAL for iOS and macOS](https://github.com/AzureAD/microsoft-authentication-library-for-objc) | iOS and macOS |
| [MSAL Go (Preview)](https://github.com/AzureAD/microsoft-authentication-library-for-go) | Windows, macOS, Linux |
| [MSAL Java](https://github.com/AzureAD/microsoft-authentication-library-for-java) | Windows, macOS, Linux |
| [MSAL.js](https://github.com/AzureAD/microsoft-authentication-library-for-js/tree/dev/lib/msal-browser) | JavaScript/TypeScript frameworks such as Vue.js, Ember.js, or Durandal.js |
| [MSAL.NET](https://github.com/AzureAD/microsoft-authentication-library-for-dotnet) | .NET Framework, .NET, .NET MAUI, WINUI, Xamarin Android, Xamarin iOS, Universal Windows Platform |
| [MSAL Node](https://github.com/AzureAD/microsoft-authentication-library-for-js/tree/dev/lib/msal-node) | Web apps with Express, desktop apps with Electron, Cross-platform console apps |
| [MSAL Python](https://github.com/AzureAD/microsoft-authentication-library-for-python) | Windows, macOS, Linux |
| [MSAL React](https://github.com/AzureAD/microsoft-authentication-library-for-js/tree/dev/lib/msal-react) | Single-page apps with React and React-based libraries (Next.js, Gatsby.js) |

#### Authentication flows

The following table shows some of the different authentication flows provided by Microsoft Authentication Library (MSAL). These flows can be used in various application scenarios.

| Authentication flow | Enables | Supported application types |
|-------------------|---------|---------------------------|
| Authorization code | User sign-in and access to web APIs on behalf of the user. | Desktop, Mobile, Single-page app (SPA) (requires PKCE), Web |
| Client credentials | Access to web APIs by using the identity of the application itself. Typically used for server-to-server communication and automated scripts requiring no user interaction. | Daemon |
| Device code | User sign-in and access to web APIs on behalf of the user on input-constrained devices like smart TVs and IoT devices. Also used by command line interface (CLI) applications. | Desktop, Mobile |
| Implicit grant | User sign-in and access to web APIs on behalf of the user. *The implicit grant flow is no longer recommended - use authorization code with PKCE instead.* | Single-page app (SPA), Web |
| On-behalf-of (OBO) | Access from an "upstream" web API to a "downstream" web API on behalf of the user. The user's identity and delegated permissions are passed through to the downstream API from the upstream API. | Web API |
| Username/password (ROPC) | Allows an application to sign in the user by directly handling their password. *The ROPC flow is NOT recommended.* | Desktop, Mobile |
| Integrated Windows authentication (IWA) | Allows applications on domain or Microsoft Entra joined computers to acquire a token silently (without any UI interaction from the user). | Desktop, Mobile |

#### Public client and confidential client applications

The Microsoft Authentication Library (MSAL) defines two types of clients; public clients and confidential clients. A client is a software entity that has a unique identifier assigned by an identity provider. The client types differ based their ability to authenticate securely with the authorization server and to hold sensitive, identity proving information so that it can't be accessed or known to a user within the scope of its access.

When examining the public or confidential nature of a given client, we're evaluating the ability of that client to prove its identity to the authorization server. This is important because the authorization server must be able to trust the identity of the client in order to issue access tokens.

- **Public client applications** run on devices, such as desktop, browserless APIs, mobile or client-side browser apps. They can't be trusted to safely keep application secrets, so they can only access web APIs on behalf of the user. Anytime the source, or compiled bytecode of a given app, is transmitted anywhere it can be read, disassembled, or otherwise inspected by untrusted parties. As they also only support public client flows and can't hold configuration-time secrets, they can't have client secrets.

- **Confidential client applications** run on servers, such as web apps, web API apps, or service/daemon apps. They're considered difficult to access by users or attackers, and therefore can adequately hold configuration-time secrets to assert proof of its identity. The client ID is exposed through the web browser, but the secret is passed only in the back channel and never directly exposed.

### Initialize client applications

With MSAL for Python, the recommended way to instantiate an application is by using the application builders: `PublicClientApplication` and `ConfidentialClientApplication`. They offer a powerful mechanism to configure the application either from the code, or from a configuration file, or even by mixing both approaches.

Before initializing an application, you first need to register it so that your app can be integrated with the Microsoft identity platform. After registration, you may need the following information (which can be found in the Azure portal):

- **Application (client) ID** - This is a string representing a GUID.
- **Directory (tenant) ID** - Provides identity and access management (IAM) capabilities to applications and resources used by your organization. It can specify if you're writing a line of business application solely for your organization (also named single-tenant application).
- The identity provider URL (named the **instance**) and the sign-in audience for your application. These two parameters are collectively known as the authority.
- **Client credentials** - which can take the form of an application secret (client secret string) or certificate (of type `X509Certificate2`) if it's a confidential client app.
- For web apps, and sometimes for public client apps (in particular when your app needs to use a broker), you need to set the **Redirect URI** where the identity provider will contact back your application with the security tokens.

#### Initializing public and confidential client applications from code

The following code instantiates a public client application, signing-in users in the Microsoft Azure public cloud, with their work and school accounts, or their personal Microsoft accounts.

```python
app = msal.PublicClientApplication(client_id)
```

In the same way, the following code instantiates a confidential application (a Web app located at ``https://myapp.azurewebsites.net``) handling tokens from users in the Microsoft Azure public cloud, with their work and school accounts, or their personal Microsoft accounts. The application is identified with the identity provider by sharing a client secret:

```python
from msal import ConfidentialClientApplication

# Initialize the confidential client application
app = ConfidentialClientApplication(
    client_id=client_id,
    client_credential=client_secret,
    authority='https://login.microsoftonline.com/common',
    redirect_uri='https://myapp.azurewebsites.net'
)
```

#### Builder modifiers

In the application builders, modifiers like `authority` and `redirect_uri` can be passed as parameters (for example, `authority` and `redirect_uri`).

- `authority` parameter: The `authority` parameter sets the application default authority to a Microsoft Entra authority, with the possibility of choosing the Azure Cloud, the audience, the tenant (tenant ID or domain name), or providing directly the authority URI.

    ```python
    from msal import PublicClientApplication

    app = PublicClientApplication(
        client_id=client_id,
        authority=f"https://login.microsoftonline.com/{tenant_id}"
    )
    ```

- `redirect_uri` parameter: The `redirect_uri` parameter overrides the default redirect URI.

    ```python
    from msal import PublicClientApplication

    app = PublicClientApplication(
        client_id=client_id,
        authority=f"https://login.microsoftonline.com/{tenant_id}",
        redirect_uri="http://localhost"
    )
    ```

#### Modifiers common to public and confidential client applications

The table below lists some of the modifiers you can set on a public, or confidential client.

| Modifier | Description |
|----------|-------------|
| .WithAuthority() | Sets the application default authority to a Microsoft Entra authority, with the possibility of choosing the Azure Cloud, the audience, the tenant (tenant ID or domain name), or providing directly the authority URI. |
| .WithTenantId(string tenantId) | Overrides the tenant ID, or the tenant description. |
| .WithClientId(string) | Overrides the client ID. |
| .WithRedirectUri(string redirectUri) | Overrides the default redirect URI. This is useful for scenarios requiring a broker. |
| .WithComponent(string) | Sets the name of the library using MSAL.NET (for telemetry reasons). |
| .WithDebugLoggingCallback() | If called, the application calls Debug.Write simply enabling debugging traces. |
| .WithLogging() | If called, the application calls a callback with debugging traces. |
| .WithTelemetry(TelemetryCallback telemetryCallback) | Sets the delegate used to send telemetry. |