# Implement user authentication and authorization

## Explore the Microsoft identity platform

### Introduction

The Microsoft identity platform for developers is a set of tools that includes authentication service, open-source libraries, and application management tools.

### Explore the Microsoft identity platform

The Microsoft identity platform helps you build applications your users and customers can sign in to using their Microsoft identities or social accounts, and provide authorized access to your own APIs or Microsoft APIs like Microsoft Graph.

There are several components that make up the Microsoft identity platform:

- **OAuth 2.0 and OpenID Connect standard-compliant authentication service** enabling developers to authenticate several identity types, including:

  - Work or school accounts, provisioned through Microsoft Entra ID
  - Personal Microsoft account, like Skype, Xbox, and Outlook.com
  - Social or local accounts, by using Azure Active Directory B2C
  - Social or local customer accounts, by using Microsoft Entra External ID
- **Open-source libraries**: Microsoft Authentication Libraries (MSAL) and support for other standards-compliant libraries

- **Microsoft identity platform endpoint**: Works with the Microsoft Authentication Libraries (MSAL) or any other standards-compliant library. It implements human readable scopes, in accordance with industry standards.

- **Application management portal**: A registration and configuration experience in the Azure portal, along with the other Azure management capabilities.

- **Application configuration API and PowerShell**: Programmatic configuration of your applications through the Microsoft Graph API and PowerShell so you can automate your DevOps tasks.

For developers, the Microsoft identity platform offers integration of modern innovations in the identity and security space like passwordless authentication, step-up authentication, and Conditional Access. You don’t need to implement such functionality yourself: applications integrated with the Microsoft identity platform natively take advantage of such innovations.

### Explore service principals

To delegate Identity and Access Management functions to Microsoft Entra ID, an application must be registered with a Microsoft Entra tenant. When you register your application with Microsoft Entra ID, you're creating an identity configuration for your application that allows it to integrate with Microsoft Entra ID. When you register an app in the Azure portal, you choose whether it is:

- **Single tenant**: only accessible in your tenant
- **Multi-tenant**: accessible in other tenants

If you register an application in the portal, an application object (the globally unique instance of the app) and a service principal object are automatically created in your home tenant. You also have a globally unique ID for your app (the app or client ID). In the portal, you can then add secrets or certificates and scopes to make your app work, customize the branding of your app in the sign-in dialog, and more.

> [!NOTE]
> You can also create service principal objects in a tenant using Azure PowerShell, Azure CLI, Microsoft Graph, and other tools.

#### Application object

A Microsoft Entra application is scoped to its one and only application object. The application object resides in the Microsoft Entra tenant where the application was registered (known as the application's "home" tenant). An application object is used as a template or blueprint to create one or more service principal objects. A service principal is created in every tenant where the application is used. Similar to a class in object-oriented programming, the application object has some static properties that are applied to all the created service principals (or application instances).

The application object describes three aspects of an application:

- How the service can issue tokens in order to access the application.
- Resources that the application might need to access.
- The actions that the application can take.

The Microsoft Graph [Application entity](https://learn.microsoft.com/en-us/graph/api/resources/application?view=graph-rest-1.0) defines the schema for an application object's properties.

#### Service principal object

To access resources secured by a Microsoft Entra tenant, the entity that is requesting access must be represented by a security principal. This is true for both users (user principal) and applications (service principal).

The security principal defines the access policy and permissions for the user/application in the Microsoft Entra tenant. This enables core features such as authentication of the user/application during sign-in, and authorization during resource access.

There are three types of service principal:

- **Application** - This type of service principal is the local representation, or application instance, of a global application object in a single tenant or directory. A service principal is created in each tenant where the application is used, and references the globally unique app object. The service principal object defines what the app can actually do in the specific tenant, who can access the app, and what resources the app can access.

- **Managed identity** - This type of service principal is used to represent a [managed identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview). Managed identities provide an identity for applications to use when connecting to resources that support Microsoft Entra authentication. When a managed identity is enabled, a service principal representing that managed identity is created in your tenant. Service principals representing managed identities can be granted access and permissions, but can't be updated or modified directly.

- **Legacy** - This type of service principal represents a legacy app, which is an app created before app registrations were introduced or an app created through legacy experiences. A legacy service principal can have:
  - credentials
  - service principal names
  - reply URLs
  - and other properties that an authorized user can edit, but doesn't have an associated app registration.

#### Relationship between application objects and service principals

The application object is the *global* representation of your application for use across all tenants, and the service principal is the *local* representation for use in a specific tenant. The application object serves as the template from which common and default properties are *derived* for use in creating corresponding service principal objects.

An application object has:

- A one to one relationship with the software application, and
- A one to many relationships with its corresponding service principal objects.

A service principal must be created in each tenant where the application is used to establish an identity for sign-in and/or access to resources being secured by the tenant. A single-tenant application has only one service principal (in its home tenant), created and consented for use during application registration. A multitenant application also has a service principal created in each tenant where a user from that tenant consented to its use.

### Discover permissions and consent

Applications that integrate with the Microsoft identity platform follow an authorization model that gives users and administrators control over how data can be accessed.

The Microsoft identity platform implements the OAuth 2.0 authorization protocol. [OAuth 2.0](https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols) is a method through which a third-party app can access web-hosted resources on behalf of a user. Any web-hosted resource that integrates with the Microsoft identity platform has a resource identifier, or *application ID URI*.

Here are some examples of Microsoft web-hosted resources:

- Microsoft Graph: `https://graph.microsoft.com`
- Microsoft 365 Mail API: `https://outlook.office.com`
- Azure Key Vault: `https://vault.azure.net`

The same is true for any third-party resources that are integrated with the Microsoft identity platform. Any of these resources also can define a set of permissions that can be used to divide the functionality of that resource into smaller chunks. When a resource's functionality is chunked into small permission sets, third-party apps can be built to request only the permissions that they need to perform their function. Users and administrators can know what data the app can access.

In OAuth 2.0, these types of *permission* sets are called scopes. They're also often referred to as permissions. In the Microsoft identity platform, a permission is represented as a string value. An app requests the permissions it needs by specifying the permission in the `scope` query parameter. Identity platform supports several well-defined [OpenID Connect scopes](https://learn.microsoft.com/en-us/entra/identity-platform/permissions-consent-overview#openid-connect-scopes) and resource-based permissions (each permission is indicated by appending the permission value to the resource's identifier or application ID URI). For example, the permission string `https://graph.microsoft.com/Calendars.Read` is used to request permission to read users calendars in Microsoft Graph.

An app most commonly requests these permissions by specifying the scopes in requests to the Microsoft identity platform authorize endpoint. However, some high-privilege permissions can be granted only through administrator consent. They can be requested or granted by using the [administrator consent endpoint](https://learn.microsoft.com/en-us/entra/identity-platform/permissions-consent-overview#admin-restricted-permissions).

> [!NOTE]
> In requests to the authorization, token or consent endpoints for the Microsoft Identity platform, if the resource identifier is omitted in the scope parameter, the resource is assumed to be Microsoft Graph. For example, `scope=User.Read` is equivalent to `https://graph.microsoft.com/User.Read`.

#### Permission types

The Microsoft identity platform supports two types of permissions: delegated access and app-only access.

- **Delegated access** are used by apps that have a signed-in user present. For these apps, either the user or an administrator consents to the permissions that the app requests. The app is delegated with the permission to act as a signed-in user when it makes calls to the target resource.

- **App-only access permissions** are used by apps that run without a signed-in user present, for example, apps that run as background services or daemons. Only an administrator can consent to app-only access permissions.

#### Consent types

Applications in Microsoft identity platform rely on consent in order to gain access to necessary resources or APIs. There are many kinds of consent that your app might need to know about in order to be successful. If you're defining permissions, you'll also need to understand how your users gain access to your app or API.

There are three consent types: *static user consent*, *incremental* and *dynamic user consent*, and *admin consent*.

##### Static user consent

In the static user consent scenario, you must specify all the permissions it needs in the app's configuration in the Azure portal. If the user (or administrator, as appropriate) hasn't granted consent for this app, then Microsoft identity platform prompts the user to provide consent at this time. Static permissions also enable administrators to consent on behalf of all users in the organization.

While static permissions of the app defined in the Azure portal keep the code nice and simple, it presents some possible issues for developers:

- The app needs to request all the permissions it would ever need upon the user's first sign-in. This can lead to a long list of permissions that discourages end users from approving the app's access on initial sign-in.

- The app needs to know all of the resources it would ever access ahead of time. It's difficult to create apps that could access an arbitrary number of resources.

##### Incremental and dynamic user consent

With the Microsoft identity platform endpoint, you can ignore the static permissions defined in the app registration information in the Azure portal and request permissions incrementally instead. You can ask for a minimum set of permissions upfront and request more over time as the customer uses more app features.

To do so, you can specify the scopes your app needs at any time by including the new scopes in the `scope` parameter when requesting an access token - without the need to predefine them in the application registration information. If the user hasn't yet consented to new scopes added to the request, they're prompted to consent only to the new permissions. Incremental, or dynamic consent, only applies to delegated permissions and not to app-only access permissions.

> [!IMPORTANT]
> Dynamic consent can be convenient, but presents a big challenge for permissions that require admin consent, since the admin consent experience doesn't know about those permissions at consent time. If you require admin privileged permissions or if your app uses dynamic consent, you must register all of the permissions in the Azure portal (not just the subset of permissions that require admin consent). This enables tenant admins to consent on behalf of all their users.

##### Admin consent

Admin consent is required when your app needs access to certain high-privilege permissions. Admin consent ensures that administrators have some other controls before authorizing apps or users to access highly privileged data from the organization.

Admin consent done on behalf of an organization still requires the static permissions registered for the app. Set those permissions for apps in the app registration portal if you need an admin to give consent on behalf of the entire organization. This reduces the cycles required by the organization admin to set up the application.

#### Requesting individual user consent

In an OpenID Connect or OAuth 2.0 authorization request, an app can request the permissions it needs by using the scope query parameter. For example, when a user signs in to an app, the app sends a request like the following example. Line breaks are added for legibility.

```http
GET https://login.microsoftonline.com/common/oauth2/v2.0/authorize?
client_id=00001111-aaaa-2222-bbbb-3333cccc4444
&response_type=code
&redirect_uri=http%3A%2F%2Flocalhost%2Fmyapp%2F
&response_mode=query
&scope=
https%3A%2F%2Fgraph.microsoft.com%2Fcalendars.read%20
https%3A%2F%2Fgraph.microsoft.com%2Fmail.send
&state=12345
```

The `scope` parameter is a space-separated list of delegated permissions that the app is requesting. Each permission is indicated by appending the permission value to the resource's identifier (the application ID URI). In the request example, the app needs permission to read the user's calendar and send mail as the user.

After the user enters their credentials, the Microsoft identity platform checks for a matching record of `user consent`. If the user hasn't consented to any of the requested permissions in the past, and if the administrator hasn't consented to these permissions on behalf of the entire organization, the Microsoft identity platform asks the user to grant the requested permissions.

### Discover conditional access

The Conditional Access feature in Microsoft Entra ID offers one of several ways that you can use to secure your app and protect a service. Conditional Access enables developers and enterprise customers to protect services in a multitude of ways including:

- [Multifactor authentication](https://learn.microsoft.com/en-us/entra/identity/authentication/concept-mfa-howitworks)
- Allowing only Intune enrolled devices to access specific services
- Restricting user locations and IP ranges

#### How does Conditional Access impact an app?

In most common cases, Conditional Access doesn't change an app's behavior or require any changes from the developer. Only in certain cases when an app indirectly or silently requests a token for a service does an app require code changes to handle Conditional Access challenges. It may be as simple as performing an interactive sign-in request.

Specifically, the following scenarios require code to handle Conditional Access challenges:

- Apps performing the on-behalf-of flow
- Apps accessing multiple services/resources
- Single-page apps using MSAL.js
- Web apps calling a resource

Conditional Access policies can be applied to the app and also a web API your app accesses. Depending on the scenario, an enterprise customer can apply and remove Conditional Access policies at any time. For your app to continue functioning when a new policy is applied, implement challenge handling.

#### Conditional Access examples

Some scenarios require code changes to handle Conditional Access whereas others work as is. Here are a few scenarios using Conditional Access to do multifactor authentication that gives some insight into the difference.

- You're building a single-tenant iOS app and apply a Conditional Access policy. The app signs in a user and doesn't request access to an API. When the user signs in, the policy is automatically invoked and the user needs to perform multifactor authentication.

- You're building an app that uses a middle tier service to access a downstream API. An enterprise customer at the company using this app applies a policy to the downstream API. When an end user signs in, the app requests access to the middle tier and sends the token. The middle tier performs on-behalf-of flow to request access to the downstream API. At this point, a claims "challenge" is presented to the middle tier. The middle tier sends the challenge back to the app, which needs to comply with the Conditional Access policy.




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

#### Constructor parameters

In MSAL Python you pass `authority` to the constructor and supply `redirect_uri` when you call an interactive or auth‐code flow method.

- `authority` parameter: sets the default Microsoft Entra authority (choosing cloud, audience, tenant ID or domain, or full URI).

```python
from msal import PublicClientApplication

app = PublicClientApplication(
    client_id=client_id,
    authority=f"https://login.microsoftonline.com/{tenant_id}"
)
```
- `redirect_uri` parameter: To override the redirect URI, pass it to methods like  `acquire_token_interactive` or `acquire_token_by_authorization_code`:

```python
# Interactive flow
result = app.acquire_token_interactive(
    scopes=["User.Read"],
    redirect_uri="http://localhost"
)
```

```python
# Authorization-code flow
result = app.acquire_token_by_authorization_code(
    code=authorization_code,
    scopes=["User.Read"],
    redirect_uri="http://localhost"
)
```
#### Parameters common to public and confidential client applications

The table below lists some of the parameters and options you can set on a public or confidential client in MSAL Python.

| Parameter                         | Description                                                                                                        |
|----------------------------------|--------------------------------------------------------------------------------------------------------------------|
| `client_id`                      | Overrides the application (client) ID.                                                                              |
| `authority`                      | Sets the Microsoft Entra authority URI (Azure cloud, audience, tenant ID/domain, or full URI).                      |
| `token_cache`                    | Specifies a custom token cache instance for persisting tokens.                                                      |
| `proxies`                        | A `dict` of proxy servers to route HTTP requests.                                                                   |
| `verify`                         | Controls TLS verification (`True`, `False`, or path to a CA bundle).                                                |
| `http_client`                    | Supplies a custom HTTP transport implementing `msal.AbstractHttpClient`.                                            |
| `redirect_uri` (acquire methods) | Overrides the redirect URI when calling `acquire_token_interactive` or `acquire_token_by_authorization_code`.       |
| `logging`                        | Enable and configure debug tracing via Python’s built-in `logging` module.                                          |

#### Parameters specific to confidential client applications
The parameters specific to a confidential client application are passed to the `ConfidentialClientApplication` constructor in MSAL Python. See the [MSAL Python API reference](https://learn.microsoft.com/en-us/python/api/msal/msal?view=msal-py-latest) for details.

Parameters such as supplying a client secret string versus a certificate dict to `client_credential` are mutually exclusive. If you provide both forms at once, MSAL Python will raise an error.

### Implement interactive authentication with MSAL Python

In this exercise, you register an application in Microsoft Entra ID, then create a Python console application that uses MSAL Python to perform interactive authentication and acquire an access token for Microsoft Graph. You learn how to configure authentication scopes, handle user consent, and see how tokens are cached for subsequent runs.

Tasks performed in this exercise:

- Register an application with the Microsoft identity platform
- Create a Python console app that implements the **PublicClientApplication** class to configure authentication.
- Acquire a token interactively using the **User.Read** Microsoft Graph permission.

This exercise takes approximately **15** minutes to complete.

#### Before you start

To complete the exercise, you need:

- An Azure subscription. If you don't already have one, you can [sign up for one](https://azure.microsoft.com/).
    
- [Visual Studio Code](https://code.visualstudio.com/) on one of the [supported platforms](https://code.visualstudio.com/docs/supporting/requirements#_platforms).
    
- [Python 3.7](https://www.python.org/downloads/) or greater.
    
- [Python extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python) for Visual Studio Code.
    

#### Register a new application

1. In your browser navigate to the Azure portal [https://portal.azure.com](https://portal.azure.com/); signing in with your Azure credentials if prompted.
    
2. In the portal, search for and select **App registrations**.
    
3. Select **+ New registration**, and when the **Register an application** page appears, enter your application's registration information:
    
    |Field|Value|
    |---|---|
    |**Name**|Enter `myMsalApplication`|
    |**Supported account types**|Select **Accounts in this organizational directory only**|
    |**Redirect URI (optional)**|Select **Public client/native (mobile & desktop)** and enter `http://localhost` in the box to the right.|
    
4. Select **Register**. Microsoft Entra ID assigns a unique application (client) ID to your app, and you're taken to your application's **Overview** page.
    
5. In the **Essentials** section of the **Overview** page record the **Application (client) ID** and the **Directory (tenant) ID**. The information is needed for the application.
    
    [![Screenshot showing the location of the fields to copy.](https://microsoftlearning.github.io/mslearn-azure-developer/instructions/azure-app-auth/media/01-app-directory-id-location.png)](https://microsoftlearning.github.io/mslearn-azure-developer/instructions/azure-app-auth/media/01-app-directory-id-location.png)
    

#### Create a Python console app to acquire a token

Now that the needed resources are deployed to Azure the next step is to set up the console application. The following steps are performed in your local environment.

1. Create a folder named **authapp**, or a name of your choosing, for the project.
    
2. Launch **Visual Studio Code** and select **File > Open folder...** and select the project folder.
    
3. Select **View > Terminal** to open a terminal.
    
4. Run the following command in the VS Code terminal to create a Python virtual environment.
    
    ```bash
    python -m venv auth-env
    ```
    
5. Activate the virtual environment:
    
    - On Windows:
        ```bash
        auth-env\Scripts\activate
        ```
    - On macOS/Linux:
        ```bash
        source auth-env/bin/activate
        ```
    
6. Run the following command to install the **msal** and **python-dotenv** packages.
    
    ```bash
    pip install msal python-dotenv
    ```
    

##### Configure the console application

In this section you create, and edit, a **.env** file to hold the secrets you recorded earlier.

1. Select **File > New file...** and create a file named _.env_ in the project folder.
    
2. Open the **.env** file and add the following code. Replace **YOUR_CLIENT_ID**, and **YOUR_TENANT_ID** with the values you recorded earlier.
    
    ```
    CLIENT_ID="YOUR_CLIENT_ID"
    TENANT_ID="YOUR_TENANT_ID"
    ```
    
3. Press **ctrl+s** to save your changes.
    

##### Add the starter code for the project

1. Create a new file named `app.py` in the project folder and add the following code. Be sure to review the comments in the code.
    
    ```python
    import os
    import msal
    from dotenv import load_dotenv
    
    # Load environment variables from .env file
    load_dotenv()
    
    # Retrieve Azure AD Application ID and tenant ID from environment variables
    client_id = os.getenv("CLIENT_ID")
    tenant_id = os.getenv("TENANT_ID")
    
    # ADD CODE TO DEFINE SCOPES AND CREATE CLIENT 
    
    
    
    # ADD CODE TO ACQUIRE AN ACCESS TOKEN
    
    
    ```
    
2. Press **ctrl+s** to save your changes.
    

##### Add code to complete the application

1. Locate the **# ADD CODE TO DEFINE SCOPES AND CREATE CLIENT** comment and add the following code directly after the comment. Be sure to review the comments in the code.
    
    ```python
    # Define the scopes required for authentication
    scopes = ["User.Read"]
    
    # Build the MSAL public client application with authority
    app = msal.PublicClientApplication(
        client_id,
        authority=f"https://login.microsoftonline.com/{tenant_id}"
    )
    ```
    
2. Locate the **# ADD CODE TO ACQUIRE AN ACCESS TOKEN** comment and add the following code directly after the comment. Be sure to review the comments in the code.
    
    ```python
    # Attempt to acquire an access token silently or interactively
    result = None
    
    # Try to acquire token silently from cache for the first available account
    accounts = app.get_accounts()
    if accounts:
        result = app.acquire_token_silent(scopes, account=accounts[0])
    
    if not result:
        # If silent token acquisition fails, prompt the user interactively
        result = app.acquire_token_interactive(scopes=scopes)
    
    # Output the acquired access token to the console
    if "access_token" in result:
        print(f"Access Token:\n{result['access_token']}")
    else:
        print(result.get("error"))
        print(result.get("error_description"))
    ```
    
3. Press **ctrl+s** to save the file.
    

#### Run the application

Now that the app is complete it's time to run it.

1. Start the application by running the following command:
    
    ```bash
    python app.py
    ```
    
2. The app opens the default browser prompting you to select the account you want to authenticate with. If there are multiple accounts listed select the one associated with the tenant used in the app.
    
3. If this is the first time you've authenticated to the registered app you receive a **Permissions requested** notification asking you to approve the app to sign you in and read your profile, and maintain access to data you have given it access to. Select **Accept**.
    
    [![Screenshot showing the permissions requested notification](https://microsoftlearning.github.io/mslearn-azure-developer/instructions/azure-app-auth/media/01-granting-permission.png)](https://microsoftlearning.github.io/mslearn-azure-developer/instructions/azure-app-auth/media/01-granting-permission.png)
    
4. You should see the results similar to the example below in the console.
    
    ```
    Access Token:
    eyJ0eXAiOiJKV1QiLCJub25jZSI6IlZF.........
    ```
    
5. Start the application a second time and notice you no longer receive the **Permissions requested** notification. The permission you granted earlier was cached.
    

#### Clean up resources

Now that you finished the exercise, you should delete the cloud resources you created to avoid unnecessary resource usage.

1. In your browser navigate to the Azure portal [https://portal.azure.com](https://portal.azure.com/); signing in with your Azure credentials if prompted.
2. Navigate to the resource group you created and view the contents of the resources used in this exercise.
3. On the toolbar, select **Delete resource group**.
4. Enter the resource group name and confirm that you want to delete it.

> **CAUTION:** Deleting a resource group deletes all resources contained within it. If you chose an existing resource group for this exercise, any existing resources outside the scope of this exercise will also be deleted.

## Implement shared access signatures
### Introduction

A shared access signature (SAS) is a URI that grants restricted access rights to Azure Storage resources. You can provide a shared access signature to clients that you want to grant delegate access to certain storage account resources.
### Discover shared access signatures

A shared access signature (SAS) is a signed URI that points to one or more storage resources and includes a token that contains a special set of query parameters. The token indicates how the resources might be accessed by the client. One of the query parameters, the signature, is constructed from the SAS parameters and signed with the key that was used to create the SAS. This signature is used by Azure Storage to authorize access to the storage resource.

#### Types of shared access signatures

Azure Storage supports three types of shared access signatures:

- **User delegation SAS**: A user delegation SAS is secured with Microsoft Entra credentials and also by the permissions specified for the SAS. A user delegation SAS applies to Blob storage only.
    
- **Service SAS**: A service SAS is secured with the storage account key. A service SAS delegates access to a resource in the following Azure Storage services: Blob storage, Queue storage, Table storage, or Azure Files.
    
- **Account SAS**: An account SAS is secured with the storage account key. An account SAS delegates access to resources in one or more of the storage services. All of the operations available via a service or user delegation SAS are also available via an account SAS.
    

> **Note**: Microsoft recommends that you use Microsoft Entra credentials when possible as a security best practice, rather than using the account key, which can be more easily compromised. When your application design requires shared access signatures for access to Blob storage, use Microsoft Entra credentials to create a user delegation SAS when possible for superior security

#### How shared access signatures work

When you use a SAS to access data stored in Azure Storage, you need two components. The first is a URI to the resource you want to access. The second part is a SAS token that you've created to authorize access to that resource.

In a single URI, such as `https://medicalrecords.blob.core.windows.net/patient-images/patient-116139-nq8z7f.jpg?sp=r&st=2020-01-20T11:42:32Z&se=2020-01-20T19:42:32Z&spr=https&sv=2019-02-02&sr=b&sig=SrW1HZ5Nb6MbRzTbXCaPm%2BJiSEn15tC91Y4umMPwVZs%3D`, you can separate the URI from the SAS token as follows:

- **URI:** `https://medicalrecords.blob.core.windows.net/patient-images/patient-116139-nq8z7f.jpg?`
- **SAS token:** `sp=r&st=2020-01-20T11:42:32Z&se=2020-01-20T19:42:32Z&spr=https&sv=2019-02-02&sr=b&sig=SrW1HZ5Nb6MbRzTbXCaPm%2BJiSEn15tC91Y4umMPwVZs%3D`

The SAS token itself is made up of several components.

|Component|Description|
|---|---|
|`sp=r`|Controls the access rights. The values can be `a` for add, `c` for create, `d` for delete, `l` for list, `r` for read, or `w` for write. This example is read only. The example `sp=acdlrw` grants all the available rights.|
|`st=2020-01-20T11:42:32Z`|The date and time when access starts.|
|`se=2020-01-20T19:42:32Z`|The date and time when access ends. This example grants eight hours of access.|
|`sv=2019-02-02`|The version of the storage API to use.|
|`sr=b`|The kind of storage being accessed. In this example, b is for blob.|
|`sig=SrW1HZ5Nb6MbRzTbXCaPm%2BJiSEn15tC91Y4umMPwVZs%3D`|The cryptographic signature.|

## Best practices

To reduce the potential risks of using a SAS, Microsoft provides some guidance:

- To securely distribute a SAS and prevent man-in-the-middle attacks, always use HTTPS.
- The most secure SAS is a user delegation SAS. Use it wherever possible because it removes the need to store your storage account key in code. You must use Microsoft Entra ID to manage credentials. This option might not be possible for your solution.
- Try to set your expiration time to the smallest useful value. If a SAS key becomes compromised, it can be exploited for only a short time.
- Apply the rule of minimum-required privileges. Only grant the access that's required. For example, in your app, read-only access is sufficient.
- There are some situations where a SAS isn't the correct solution. When there's an unacceptable risk of using a SAS, create a middle-tier service to manage users and their access to storage.


### Choose when to use shared access signatures

Use a SAS when you want to provide secure access to resources in your storage account to any client who doesn't otherwise have permissions to those resources.

A common scenario where a SAS is useful is a service where users read and write their own data to your storage account. In a scenario where a storage account stores user data, there are two typical design patterns:

- Clients upload and download data via a front-end proxy service, which performs authentication. This front-end proxy service has the advantage of allowing validation of business rules, but for large amounts of data or high-volume transactions, creating a service that can scale to match demand may be expensive or difficult.
    
    ![Scenario diagram: Front-end proxy service](https://learn.microsoft.com/en-gb/training/wwl-azure/implement-shared-access-signatures/media/storage-proxy-service.png)
    
- A lightweight service authenticates the client as needed and then generates a SAS. Once the client application receives the SAS, they can access storage account resources directly with the permissions defined by the SAS and for the interval allowed by the SAS. The SAS mitigates the need for routing all data through the front-end proxy service.
    
    ![Scenario diagram: SAS provider service](https://learn.microsoft.com/en-gb/training/wwl-azure/implement-shared-access-signatures/media/storage-provider-service.png)
    

Many real-world services might use a hybrid of these two approaches. For example, some data might be processed and validated via the front-end proxy, while other data is saved and/or read directly using SAS.

Additionally, a SAS is required to authorize access to the source object in a copy operation in certain scenarios:

- When you copy a blob to another blob that resides in a different storage account, you must use a SAS to authorize access to the source blob. You can optionally use a SAS to authorize access to the destination blob as well.
    
- When you copy a file to another file that resides in a different storage account, you must use a SAS to authorize access to the source file. You can optionally use a SAS to authorize access to the destination file as well.
    
- When you copy a blob to a file, or a file to a blob, you must use a SAS to authorize access to the source object, even if the source and destination objects reside within the same storage account.

### Explore stored access policies

A stored access policy provides an extra level of control over service-level shared access signatures (SAS) on the server side. Establishing a stored access policy groups SAS and provides more restrictions for signatures that bound by the policy. You can use a stored access policy to change the start time, expiry time, or permissions for a signature, or to revoke it after it is issued.

The following storage resources support stored access policies:

- Blob containers
- File shares
- Queues
- Tables

#### Creating a stored access policy

The access policy for a SAS consists of the start time, expiry time, and permissions for the signature. You can specify all of these parameters on the signature URI and none within the stored access policy; all on the stored access policy and none on the URI; or some combination of the two. However, you can't specify a given parameter on both the SAS token and the stored access policy.

To create or modify a stored access policy, call the `Set ACL` operation for the resource (see [Set Container ACL](https://learn.microsoft.com/en-us/rest/api/storageservices/set-container-acl), [Set Queue ACL](https://learn.microsoft.com/en-us/rest/api/storageservices/set-queue-acl), [Set Table ACL](https://learn.microsoft.com/en-us/rest/api/storageservices/set-table-acl), or [Set Share ACL](https://learn.microsoft.com/en-us/rest/api/storageservices/set-share-acl)) with a request body that specifies the terms of the access policy. The body of the request includes a unique signed identifier of your choosing, up to 64 characters in length, and the optional parameters of the access policy, as follows:

>**Note**: When you establish a stored access policy on a container, table, queue, or share, it may take up to 30 seconds to take effect. During this time requests against a SAS associated with the stored access policy may fail with status code 403 (Forbidden), until the access policy becomes active. Table entity range restrictions (`startpk`, `startrk`, `endpk`, and `endrk`) cannot be specified in a stored access policy.

Following are examples of creating a stored access policy by using Python and the Azure CLI.

```python
from azure.storage.blob import BlobServiceClient, AccessPolicy, ContainerSasPermissions
from datetime import datetime, timedelta, timezone

# Create a BlobServiceClient
blob_service_client = BlobServiceClient(account_url="https://<account_name>.blob.core.windows.net", credential="<account_key>")

# Get a container client
container_client = blob_service_client.get_container_client("your-container-name")

# Define the access policy
access_policy = AccessPolicy(
    permission=ContainerSasPermissions(read=True, write=True),
    expiry=datetime.now(timezone.utc) + timedelta(hours=1),
    start=datetime.now(timezone.utc)
)

# Create the stored access policy
signed_identifiers = {
    "stored-access-policy-identifier": access_policy
}

# Set the access policy on the container
container_client.set_container_access_policy(signed_identifiers=signed_identifiers)
```

```bash
az storage container policy create \
    --name <stored access policy identifier> \
    --container-name <container name> \
    --start <start time UTC datetime> \
    --expiry <expiry time UTC datetime> \
    --permissions <(a)dd, (c)reate, (d)elete, (l)ist, (r)ead, or (w)rite> \
    --account-key <storage account key> \
    --account-name <storage account name> \
```

#### Modifying or revoking a stored access policy

To modify the parameters of the stored access policy you can call the access control list operation for the resource type to replace the existing policy. For example, if your existing policy grants read and write permissions to a resource, you can modify it to grant only read permissions for all future requests.

To revoke a stored access policy you can delete it, rename it by changing the signed identifier, or change the expiry time to a value in the past. Changing the signed identifier breaks the associations between any existing signatures and the stored access policy. Changing the expiry time to a value in the past causes any associated signatures to expire. Deleting or modifying the stored access policy immediately affects all of the SAS associated with it.

To remove a single access policy, call the resource's `Set ACL` operation, passing in the set of signed identifiers that you wish to maintain on the container. To remove all access policies from the resource, call the `Set ACL` operation with an empty request body.

## Explore Microsoft Graph
### Introduction
Use the wealth of data in Microsoft Graph to build apps for organizations and consumers that interact with millions of users.

### Discover Microsoft Graph


Microsoft Graph is the gateway to data and intelligence in Microsoft 365. It provides a unified programmability model that you can use to access the tremendous amount of data in Microsoft 365, Windows 10, and Enterprise Mobility + Security.

![Microsoft Graph, Microsoft Graph data connect, and Microsoft Graph connectors enable extending Microsoft 365 experiences and building intelligent apps.](https://learn.microsoft.com/en-gb/training/wwl-azure/microsoft-graph/media/microsoft-graph-data-connectors.png)

In the Microsoft 365 platform, three main components facilitate the access and flow of data:

- The Microsoft Graph API offers a single endpoint, `https://graph.microsoft.com`. You can use REST APIs or SDKs to access the endpoint. Microsoft Graph also includes services that manage user and device identity, access, compliance, and security.
    
- [Microsoft Graph connectors](https://learn.microsoft.com/en-us/microsoftsearch/connectors-overview) work in the incoming direction, **delivering data external to the Microsoft cloud into Microsoft Graph services and applications**, to enhance Microsoft 365 experiences such as Microsoft Search. Connectors exist for many commonly used data sources such as Box, Google Drive, Jira, and Salesforce.
    
- [Microsoft Graph Data Connect](https://learn.microsoft.com/en-us/graph/overview#access-microsoft-graph-data-at-scale-using-microsoft-graph-data-connect) provides a set of tools to streamline secure and scalable **delivery of Microsoft Graph data to popular Azure data stores**. The cached data serves as data sources for Azure development tools that you can use to build intelligent applications.

### Query Microsoft Graph by using REST


Microsoft Graph is a RESTful web API that enables you to access Microsoft Cloud service resources. After you register your app and get authentication tokens for a user or service, you can make requests to the Microsoft Graph API.

The Microsoft Graph API defines most of its resources, methods, and enumerations in the OData namespace, `microsoft.graph`, in the [Microsoft Graph metadata](https://learn.microsoft.com/en-us/graph/traverse-the-graph#microsoft-graph-api-metadata). A few API sets are defined in their subnamespaces, such as the [call records API](https://learn.microsoft.com/en-us/graph/api/resources/callrecords-api-overview) which defines resources like [callRecord](https://learn.microsoft.com/en-us/graph/api/resources/callrecords-callrecord) in `microsoft.graph.callRecords`.

Unless explicitly specified in the corresponding topic, assume types, methods, and enumerations are part of the `microsoft.graph` namespace.

#### Call a REST API method

To read from or write to a resource such as a user or an email message, construct a request that looks like the following sample:

```bash
{HTTP method} https://graph.microsoft.com/{version}/{resource}?{query-parameters}
```

The components of a request include:

- `{HTTP method}` - The HTTP method used on the request to Microsoft Graph.
- `{version}` - The version of the Microsoft Graph API your application is using.
- `{resource}` - The resource in Microsoft Graph that you're referencing.
- `{query-parameters}` - Optional OData query options or REST method parameters that customize the response.

After you make a request, a response is returned that includes:

- Status code - An HTTP status code that indicates success or failure.
- Response message - The data that you requested or the result of the operation. The response message can be empty for some operations.
- `nextLink` - If your request returns numerous data, you need to page through it by using the URL returned in `@odata.nextLink`.

#### HTTP methods

Microsoft Graph uses the HTTP method on your request to determine what your request is doing. The API supports the following methods.

|Method|Description|
|---|---|
|GET|Read data from a resource.|
|POST|Create a new resource, or perform an action.|
|PATCH|Update a resource with new values.|
|PUT|Replace a resource with a new one.|
|DELETE|Remove a resource.|

- For the CRUD methods `GET` and `DELETE`, no request body is required.
- The `POST`, `PATCH`, and `PUT` methods require a request body specified in JSON format that contains additional information. Such as the values for properties of the resource.

#### Version

Microsoft Graph currently supports two versions: `v1.0` and `beta`.

- `v1.0` includes generally available APIs. Use the v1.0 version for all production apps.
- `beta` includes APIs that are currently in preview. Because we might introduce breaking changes to our beta APIs, we recommend that you use the beta version only to test apps that are in development; don't use beta APIs in your production apps.

#### Resource

A resource can be an entity or complex type, commonly defined with properties. Entities differ from complex types by always including an **id** property.

Your URL includes the resource you're interacting with in the request, such as `me`, **user**, **group**, **drive**, and **site**. Often, top-level resources also include _relationships_, which you can use to access other resources, like `me/messages` or `me/drive`. You can also interact with resources using _methods_; for example, to send an email, use `me/sendMail`.

Each resource might require different permissions to access it. You often need a higher level of permissions to create or update a resource than to read it. For details about required permissions, see the method reference topic.

#### Query parameters

Query parameters can be OData system query options, or other strings that a method accepts to customize its response.

You can use optional OData system query options to include more or fewer properties than the default response. You can filter the response for items that match a custom query, or provide another parameters for a method.

For example, adding the following `filter` parameter restricts the messages returned with the `emailAddress` property of `jon@contoso.com`.

```bash
GET https://graph.microsoft.com/v1.0/me/messages?filter=emailAddress eq 'jon@contoso.com'
```

#### Other resources

Following are links to some tools you can use to build and test requests using Microsoft Graph APIs.

- [Graph Explorer](https://developer.microsoft.com/graph/graph-explorer)
- [Postman](https://www.getpostman.com/)

### Query Microsoft Graph by using SDKs

The Microsoft Graph SDKs are designed to simplify building high-quality, efficient, and resilient applications that access Microsoft Graph. The SDKs include two components: a service library and a core library.

The service library contains models and request builders that are generated from Microsoft Graph metadata to provide a rich and discoverable experience.

The core library provides a set of features that enhance working with all the Microsoft Graph services. Embedded support for retry handling, secure redirects, transparent authentication, and payload compression, improve the quality of your application's interactions with Microsoft Graph, with no added complexity, while leaving you completely in control. The core library also provides support for common tasks such as paging through collections and creating batch requests.

#### Install the Microsoft Graph Python SDK

The Microsoft Graph Python SDK is included in the following pip packages:

- [msgraph-sdk-python](https://github.com/microsoftgraph/msgraph-sdk-python) - Contains the models and request builders for accessing the `v1.0` endpoint with a fluent API.
-  [msgraph-beta-sdk-python](https://github.com/microsoftgraph/msgraph-beta-sdk-python) - Contains the models and request builders for accessing the `beta` endpoint with the fluent API. `Microsoft.Graph.Beta` has a dependency on `Microsoft.Graph.Core`.

#### Create a Microsoft Graph client

The Microsoft Graph client is designed to make it simple to make calls to Microsoft Graph. You can use a single client instance for the lifetime of the application. The following code examples show how to create an instance of a Microsoft Graph client. The authentication provider handles acquiring access tokens for the application. The different application providers support different client scenarios. For details about which provider and options are appropriate for your scenario, see [Choose an Authentication Provider](https://learn.microsoft.com/en-us/graph/sdks/choose-authentication-providers).

```python
from azure.identity import DeviceCodeCredential

from msgraph.core import GraphClient

# Define the required scopes

scopes = ["User.Read"]

tenant_id = "common"

client_id = "YOUR_CLIENT_ID"

# Define the callback function to display the device code message

def device_code_callback(device_code):

    print(device_code["message"])

# Create the DeviceCodeCredential

credential = DeviceCodeCredential(

    client_id=client_id,

    tenant_id=tenant_id,

    prompt_callback=device_code_callback

)

# Create the Graph client

graph_client = GraphClient(credential=credential, scopes=scopes)

# Example: Get the current user's profile

response = graph_client.get('/me')

print(response.json())
```

#### Read information from Microsoft Graph

To retrieve data from Microsoft Graph in Python, you can use the `GraphClient` to send a GET request to the desired endpoint. For example, to access the signed-in user's profile information:

```python
response = graph_client.get('/me')

print(response.json())
```

#### Retrieve a list of entities

To retrieve a collection of entities such as messages, you can send a GET request to the appropriate endpoint and customize the results using query parameters like `$select` to choose specific fields, and `$filter` to narrow down the results based on conditions.

```python
query_params = {

    "$select": "subject,sender",

    "$filter": "subject eq 'Hello world'"

}

response = graph_client.get('/me/messages', params=query_params)

print(response.json())
```

#### Delete an entity

To delete an entity using Microsoft Graph, construct the request similarly to how you would retrieve an entity, but use the `DELETE` HTTP method instead of `GET`.

```python
from msgraph import GraphServiceClient

from azure.identity.aio import DeviceCodeCredential

# Set up authentication

credential = DeviceCodeCredential(client_id="YOUR_CLIENT_ID")

graph_client = GraphServiceClient(credential)

# Message ID to delete

message_id = "YOUR_MESSAGE_ID"

# Delete the message

await graph_client.me.messages.by_message_id(message_id).delete()
```

#### Create a new entity

In fluent-style and template-based SDKs, new items can be added to collections using the `POST` method.

```python
from msgraph import GraphServiceClient

from azure.identity.aio import DeviceCodeCredential

from msgraph.generated.models.calendar import Calendar


credential = DeviceCodeCredential(client_id="YOUR_CLIENT_ID")

graph_client = GraphServiceClient(credential)

# Create a new calendar object

calendar = Calendar(name="Volunteer")

# Send POST request to create the calendar

new_calendar = await graph_client.me.calendars.post(calendar)

print(f"Created calendar: {new_calendar.id}")
```

#### Other resources

- [Microsoft Graph REST API v1.0 reference](https://learn.microsoft.com/en-us/graph/api/overview)
### Apply best practices to Microsoft Graph

#### Authentication

To access the data in Microsoft Graph, your application needs to acquire an OAuth 2.0 access token, and presents it to Microsoft Graph in either of the following methods:

- The HTTP _Authorization_ request header, as a _Bearer_ token
- The graph client constructor, when using a Microsoft Graph client library

Use the Microsoft Authentication Library API, [MSAL](https://learn.microsoft.com/en-us/azure/active-directory/develop/active-directory-v2-libraries) to acquire the access token to Microsoft Graph.

#### Consent and authorization

Apply the following best practices for consent and authorization in your app:

- **Use least privilege**. Only request permissions that are necessary, and only when you need them. For the APIs, your application calls check the permissions section in the method topics. For example, see [creating a user](https://learn.microsoft.com/en-us/graph/api/user-post-users) and choose the least privileged permissions.
    
- **Use the correct permission type based on scenarios**. If you're building an interactive application where a signed in user is present, your application should use _delegated_ permissions. If, however, your application runs without a signed-in user, such as a background service or daemon, your application should use application permissions.
    
     > **Caution**: Using application permissions for interactive scenarios can put your application at compliance and security risk. Be sure to check user's privileges to ensure they don't have undesired access to information, or are circumnavigating policies configured by an administrator.
    
- **Consider the end user and admin experience**. Directly affects end user and admin experiences. For example:
    
    - Consider who is consenting to your application, either end users or administrators, and configure your application to [request permissions appropriately](https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent).
        
    - Ensure that you understand the difference between [static, dynamic, and incremental consent](https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-permissions-and-consent#consent-types).
        
- **Consider multi-tenant applications**. Expect customers to have various application and consent controls in different states. For example:
    
    - Tenant administrators can disable the ability for end users to consent to applications. In this case, an administrator would need to consent on behalf of their users.
        
    - Tenant administrators can set custom authorization policies such as blocking users from reading other user's profiles, or limiting self-service group creation to a limited set of users. In this case, your application should expect to handle 403 error response when acting on behalf of a user.

#### Handle responses effectively

Depending on the requests you make to Microsoft Graph, your applications should be prepared to handle different types of responses. The following are some of the most important practices to follow to ensure that your application behaves reliably and predictably for your end users. For example:

- **Pagination**: When querying resource collections, you should expect that Microsoft Graph returns the result set in multiple pages, due to server-side page size limits. Your application should **always** handle the possibility that the responses are paged in nature, and use the `@odata.nextLink` property to obtain the next paged set of results, until all pages of the result set are read. The final page doesn't include an `@odata.nextLink` property. For more information, visit [paging](https://learn.microsoft.com/en-us/graph/paging).
    
- **Evolvable enumerations**: Adding members to existing enumerations can break applications already using these enums. Evolvable enums are a mechanism that Microsoft Graph API uses to add new members to existing enumerations without causing a breaking change for applications. By default, a GET operation returns only known members for properties of evolvable enum types and your application needs to handle only the known members. If you design your application to handle unknown members as well, you can opt in to receive those members by using an HTTP `Prefer` request header.

#### Storing data locally

Your application should ideally make calls to Microsoft Graph to retrieve data in real time as necessary. You should only cache or store data locally necessary for a specific scenario. If that use case is covered by your terms of use and privacy policy, and doesn't violate the [Microsoft APIs Terms of Use](https://learn.microsoft.com/en-us/legal/microsoft-apis/terms-of-use?context=/graph/context), your application should also implement proper retention and deletion policies.

### Retrieve user profile information with the Microsoft Graph SDK

In this exercise, you create a Python app to authenticate with Microsoft Entra ID and request an access token, then call the Microsoft Graph API to retrieve and display your user profile information. You learn how to configure permissions and interact with Microsoft Graph from your application.

Tasks performed in this exercise:

- Register an application with the Microsoft identity platform
- Create a Python console application that implements interactive authentication, and uses the **GraphServiceClient** class to retrieve user profile information.

This exercise takes approximately **15** minutes to complete.

#### Before you start

To complete the exercise, you need:

- An Azure subscription. If you don't already have one, you can [sign up for one](https://azure.microsoft.com/).
    
- [Visual Studio Code](https://code.visualstudio.com/) on one of the [supported platforms](https://code.visualstudio.com/docs/supporting/requirements#_platforms).
    
- [Python 3.8](https://www.python.org/downloads/) or greater.
    
- [Python extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python) for Visual Studio Code.
    

#### Register a new application

1. In your browser navigate to the Azure portal [https://portal.azure.com](https://portal.azure.com/); signing in with your Azure credentials if prompted.
    
2. In the portal, search for and select **App registrations**.
    
3. Select **+ New registration**, and when the **Register an application** page appears, enter your application's registration information:
    
    |Field|Value|
    |---|---|
    |**Name**|Enter `myGraphApplication`|
    |**Supported account types**|Select **Accounts in this organizational directory only**|
    |**Redirect URI (optional)**|Select **Public client/native (mobile & desktop)** and enter `http://localhost` in the box to the right.|
    
4. Select **Register**. Microsoft Entra ID assigns a unique application (client) ID to your app, and you're taken to your application's **Overview** page.
    
5. In the **Essentials** section of the **Overview** page record the **Application (client) ID** and the **Directory (tenant) ID**. The information is needed for the application.
    
    [![Screenshot showing the location of the fields to copy.](https://microsoftlearning.github.io/mslearn-azure-developer/instructions/azure-app-auth/media/01-app-directory-id-location.png)](https://microsoftlearning.github.io/mslearn-azure-developer/instructions/azure-app-auth/media/01-app-directory-id-location.png)
    

#### Create a Python console app to send and receive messages

Now that the needed resources are deployed to Azure the next step is to set up the console application. The following steps are performed in your local environment.

1. Create a folder named **graphapp**, or a name of your choosing, for the project.
    
2. Launch **Visual Studio Code** and select **File > Open folder...** and select the project folder.
    
3. Select **View > Terminal** to open a terminal.
    
4. Run the following command in the VS Code terminal to create a virtual environment and activate it.
    
    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows: venv\Scripts\activate
    ```
    
5. Run the following commands to install the **azure-identity**, **msgraph-sdk**, and **python-dotenv** packages.
    
    ```bash
    pip install azure-identity msgraph-sdk python-dotenv
    ```
    

##### Configure the console application

In this section you create, and edit, a **.env** file to hold the secrets you recorded earlier.

1. Select **File > New file...** and create a file named _.env_ in the project folder.
    
2. Open the **.env** file and add the following code. Replace **YOUR_CLIENT_ID**, and **YOUR_TENANT_ID** with the values you recorded earlier.
    
    ```
    CLIENT_ID="YOUR_CLIENT_ID"
    TENANT_ID="YOUR_TENANT_ID"
    ```
    
3. Press **ctrl+s** or **cmd+s** on Mac to save the file.
    

##### Add the starter code for the project

1. Create a new file named _main.py_ in the project folder and add the following code. Be sure to review the comments in the code.
    
    ```python
    import os
    import asyncio
    from dotenv import load_dotenv
    from azure.identity import InteractiveBrowserCredential
    from msgraph import GraphServiceClient

    async def get_user_profile(graph_client: GraphServiceClient):
        """Function to get and print the signed-in user's profile"""
        try:
            # Call Microsoft Graph /me endpoint to get user info
            me = await graph_client.me.get()
            print(f"Display Name: {me.display_name}")
            print(f"Principal Name: {me.user_principal_name}")
            print(f"User Id: {me.id}")
        except Exception as ex:
            # Print any errors encountered during the call
            print(f"Error retrieving profile: {ex}")

    async def main():
        # Load environment variables from .env file (if present)
        load_dotenv()
        
        # Read Azure AD app registration values from environment
        client_id = os.getenv("CLIENT_ID")
        tenant_id = os.getenv("TENANT_ID")
        
        # Validate that required environment variables are set
        if not client_id or not tenant_id:
            print("Please set CLIENT_ID and TENANT_ID environment variables.")
            return
        
        # ADD CODE TO DEFINE SCOPE AND CONFIGURE AUTHENTICATION
        
        
        
        # ADD CODE TO CREATE GRAPH CLIENT AND RETRIEVE USER PROFILE
        

    if __name__ == "__main__":
        asyncio.run(main())
    ```
    
2. Press **ctrl+s** or **cmd+s** on Mac to save your changes.
    

##### Add code to complete the application

1. Locate the **# ADD CODE TO DEFINE SCOPE AND CONFIGURE AUTHENTICATION** comment and add the following code directly after the comment. Be sure to review the comments in the code.
    
    ```python
    # Define the Microsoft Graph permission scopes required by this app
    scopes = ["User.Read"]
    
    # Configure interactive browser authentication for the user
    credential = InteractiveBrowserCredential(
        client_id=client_id,  # Azure AD app client ID
        tenant_id=tenant_id,  # Azure AD tenant ID
        redirect_uri="http://localhost"  # Redirect URI for auth flow
    )
    ```
    
2. Locate the **# ADD CODE TO CREATE GRAPH CLIENT AND RETRIEVE USER PROFILE** comment and add the following code directly after the comment. Be sure to review the comments in the code.
    
    ```python
    # Create a Microsoft Graph client using the credential
    graph_client = GraphServiceClient(credentials=credential, scopes=scopes)
    
    # Retrieve and display the user's profile information
    print("Retrieving user profile...")
    await get_user_profile(graph_client)
    ```
    
3. Press **ctrl+s** or **cmd+s** on Mac to save the file.
    

#### Run the application

Now that the app is complete it's time to run it.

1. Start the application by running the following command:
    
    ```bash
    python main.py
    ```
    
2. The app opens the default browser prompting you to select the account you want to authenticate with. If there are multiple accounts listed select the one associated with the tenant used in the app.
    
3. If this is the first time you've authenticated to the registered app you receive a **Permissions requested** notification asking you to approve the app to sign you in and read your profile, and maintain access to data you have given it access to. Select **Accept**.
    
    [![Screenshot showing the permissions requested notification](https://microsoftlearning.github.io/mslearn-azure-developer/instructions/azure-app-auth/media/01-granting-permission.png)](https://microsoftlearning.github.io/mslearn-azure-developer/instructions/azure-app-auth/media/01-granting-permission.png)
    
4. You should see the results similar to the example below in the console.
    
    ```
    Retrieving user profile...
    Display Name: <Your account display name>
    Principal Name: <Your principal name>
    User Id: 9f5...
    ```
    
5. Start the application a second time and notice you no longer receive the **Permissions requested** notification. The permission you granted earlier was cached.
    

#### Clean up resources

Now that you finished the exercise, you should delete the cloud resources you created to avoid unnecessary resource usage.

1. In your browser navigate to the Azure portal [https://portal.azure.com](https://portal.azure.com/); signing in with your Azure credentials if prompted.
2. Navigate to the resource group you created and view the contents of the resources used in this exercise.
3. On the toolbar, select **Delete resource group**.
4. Enter the resource group name and confirm that you want to delete it.

> **CAUTION:** Deleting a resource group deletes all resources contained within it. If you chose an existing resource group for this exercise, any existing resources outside the scope of this exercise will also be deleted.
