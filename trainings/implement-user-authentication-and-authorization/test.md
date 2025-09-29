# Query Microsoft Graph by using SDKs# 

The Microsoft Graph SDKs are designed to simplify building high-quality, efficient, and resilient applications that access Microsoft Graph. The SDKs include two components: a service library and a core library.T## Delete an entity



The service library contains models and request builders that are generated from Microsoft Graph metadata to provide a rich and discoverable experience.## Create a new entity



The core library provides a set of features that enhance working with all the Microsoft Graph services. Embedded support for retry handling, secure redirects, transparent authentication, and payload compression, improve the quality of your application's interactions with Microsoft Graph, with no added complexity, while leaving you completely in control. The core library also provides support for common tasks such as paging through collections and creating batch requests.For fluent style and template-based SDKs, new items can be added to collections with a `POST` method.



In this unit, you learn about the available SDKs and see some code examples of some of the most common operations.```python

# POST https://graph.microsoft.com/v1.0/me/calendars

 Notefrom msgraph.generated.models.calendar import Calendar



The code samples in this unit are based on the Microsoft Graph Python SDK (msgraph-sdk-python).calendar = Calendar()

calendar.name = "Volunteer"

## Install the Microsoft Graph Python SDK

new_calendar = await graph_client.me.calendars.post(calendar)

The Microsoft Graph Python SDK can be installed using pip:```are constructed in the same way as requests to retrieve an entity, but use a `DELETE` request instead of a `GET`.



```bash```python

pip install msgraph-sdk# DELETE https://graph.microsoft.com/v1.0/me/messages/{message-id}

pip install azure-identity# message_id is a string containing the id property of the message

```await graph_client.me.messages.by_message_id(message_id).delete()

```mation from Microsoft Graph, you first need to create a request object, and then run the `GET` method on the request.

The main packages are:

```python

- [msgraph-sdk](https://github.com/microsoftgraph/msgraph-sdk-python) - Contains the models and request builders for accessing Microsoft Graph with the fluent API.# GET https://graph.microsoft.com/v1.0/me

- [azure-identity](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/identity/azure-identity) - Provides authentication credential classes for Azure Active Directory authentication.

user = await graph_client.me.get()

## Create a Microsoft Graph client``` Python SDK (msgraph-sdk-python).



The Microsoft Graph client is designed to make it simple to make calls to Microsoft Graph. You can use a single client instance for the lifetime of the application. The following code examples show how to create an instance of a Microsoft Graph client. The authentication provider handles acquiring access tokens for the application. The different application providers support different client scenarios. For details about which provider and options are appropriate for your scenario, see [Choose an Authentication Provider](https://learn.microsoft.com/en-us/graph/sdks/choose-authentication-providers).## Install the Microsoft Graph Python SDK



```pythonThe Microsoft Graph Python SDK can be installed using pip:

from azure.identity import DeviceCodeCredential

from msgraph import GraphServiceClient```bash

pip install msgraph-sdk

# Define scopespip install azure-identity

scopes = ["User.Read"]```



# Multi-tenant apps can use "common",The main packages are:

# single-tenant apps must use the tenant ID from the Azure portal

tenant_id = "common"- [msgraph-sdk](https://github.com/microsoftgraph/msgraph-sdk-python) - Contains the models and request builders for accessing Microsoft Graph with the fluent API.

- [azure-identity](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/identity/azure-identity) - Provides authentication credential classes for Azure Active Directory authentication.aph by using SDKs

# Value from app registration

client_id = "YOUR_CLIENT_ID"

The Microsoft Graph SDKs are designed to simplify building high-quality, efficient, and resilient applications that access Microsoft Graph. The SDKs include two components: a service library and a core library.

# Create device code credential

credential = DeviceCodeCredential(The service library contains models and request builders that are generated from Microsoft Graph metadata to provide a rich and discoverable experience.

    client_id=client_id,

    tenant_id=tenant_idThe core library provides a set of features that enhance working with all the Microsoft Graph services. Embedded support for retry handling, secure redirects, transparent authentication, and payload compression, improve the quality of your application's interactions with Microsoft Graph, with no added complexity, while leaving you completely in control. The core library also provides support for common tasks such as paging through collections and creating batch requests.

)

In this unit, you learn about the available SDKs and see some code examples of some of the most common operations.

# Create Graph client

graph_client = GraphServiceClient(credentials=credential, scopes=scopes) Note

```

The code samples in this unit are based on the Microsoft Graph Python SDK (msgraph-sdk-python).## Install the Microsoft Graph .NET SDK

## Read information from Microsoft Graph

The Microsoft Graph .NET SDK is included in the following NuGet packages:

To read information from Microsoft Graph, you first need to create a request object, and then run the `GET` method on the request.

- [Microsoft.Graph](https://github.com/microsoftgraph/msgraph-sdk-dotnet) - Contains the models and request builders for accessing the `v1.0` endpoint with the fluent API. `Microsoft.Graph` has a dependency on `Microsoft.Graph.Core`.

```python- [Microsoft.Graph.Beta](https://github.com/microsoftgraph/msgraph-beta-sdk-dotnet) - Contains the models and request builders for accessing the `beta` endpoint with the fluent API. `Microsoft.Graph.Beta` has a dependency on `Microsoft.Graph.Core`.

# GET https://graph.microsoft.com/v1.0/me- [Microsoft.Graph.Core](https://github.com/microsoftgraph/msgraph-sdk-dotnet) - The core library for making calls to Microsoft Graph.



user = await graph_client.me.get()## Create a Microsoft Graph client

```

The Microsoft Graph client is designed to make it simple to make calls to Microsoft Graph. You can use a single client instance for the lifetime of the application. The following code examples show how to create an instance of a Microsoft Graph client. The authentication provider handles acquiring access tokens for the application. The different application providers support different client scenarios. For details about which provider and options are appropriate for your scenario, see [Choose an Authentication Provider](https://learn.microsoft.com/en-us/graph/sdks/choose-authentication-providers).

## Retrieve a list of entities

```python

Retrieving a list of entities is similar to retrieving a single entity except there are other options for configuring the request. The `$filter` query parameter can be used to reduce the result set to only those rows that match the provided condition. The `$orderBy` query parameter requests that the server provides the list of entities sorted by the specified properties.from azure.identity import DeviceCodeCredential

from msgraph import GraphServiceClient

```python

# GET https://graph.microsoft.com/v1.0/me/messages?# Define scopes

# $select=subject,sender&$filter=subject eq 'Hello world'scopes = ["User.Read"]



from msgraph.generated.me.messages.messages_request_builder import MessagesRequestBuilder# Multi-tenant apps can use "common",

# single-tenant apps must use the tenant ID from the Azure portal

query_params = MessagesRequestBuilder.MessagesRequestBuilderGetQueryParameters(tenant_id = "common"

    select=["subject", "sender"],

    filter="subject eq 'Hello world'"# Value from app registration

)client_id = "YOUR_CLIENT_ID"



request_configuration = MessagesRequestBuilder.MessagesRequestBuilderGetRequestConfiguration(# Create device code credential

    query_parameters=query_paramscredential = DeviceCodeCredential(

)    client_id=client_id,

    tenant_id=tenant_id

messages = await graph_client.me.messages.get(request_configuration=request_configuration))

```

# Create Graph client

## Delete an entitygraph_client = GraphServiceClient(credentials=credential, scopes=scopes)

```

Delete requests are constructed in the same way as requests to retrieve an entity, but use a `DELETE` request instead of a `GET`.

## Read information from Microsoft Graph

```python

# DELETE https://graph.microsoft.com/v1.0/me/messages/{message-id}To read information from Microsoft Graph, you first need to create a request object, and then run the `GET` method on the request.

# message_id is a string containing the id property of the message

await graph_client.me.messages.by_message_id(message_id).delete()C#Copy

```

```

## Create a new entity// GET https://graph.microsoft.com/v1.0/me



For fluent style and template-based SDKs, new items can be added to collections with a `POST` method.var user = await graphClient.Me

    .GetAsync();

```python```

# POST https://graph.microsoft.com/v1.0/me/calendars

from msgraph.generated.models.calendar import Calendar## Retrieve a list of entities



calendar = Calendar()Retrieving a list of entities is similar to retrieving a single entity except there are other options for configuring the request. The `$filter` query parameter can be used to reduce the result set to only those rows that match the provided condition. The `$orderBy` query parameter requests that the server provides the list of entities sorted by the specified properties.

calendar.name = "Volunteer"

```python

new_calendar = await graph_client.me.calendars.post(calendar)# GET https://graph.microsoft.com/v1.0/me/messages?

```# $select=subject,sender&$filter=subject eq 'Hello world'



## Other resourcesfrom msgraph.generated.me.messages.messages_request_builder import MessagesRequestBuilder



- [Microsoft Graph REST API v1.0 reference](https://learn.microsoft.com/en-us/graph/api/overview)query_params = MessagesRequestBuilder.MessagesRequestBuilderGetQueryParameters(
    select=["subject", "sender"],
    filter="subject eq 'Hello world'"
)

request_configuration = MessagesRequestBuilder.MessagesRequestBuilderGetRequestConfiguration(
    query_parameters=query_params
)

messages = await graph_client.me.messages.get(request_configuration=request_configuration)
```

## Delete an entity

Delete requests are constructed in the same way as requests to retrieve an entity, but use a `DELETE` request instead of a `GET`.

C#Copy

```
// DELETE https://graph.microsoft.com/v1.0/me/messages/{message-id}
// messageId is a string containing the id property of the message
await graphClient.Me.Messages[messageId]
    .DeleteAsync();
```

## Create a new entity

For fluent style and template-based SDKs, new items can be added to collections with a `POST` method.

C#Copy

```
// POST https://graph.microsoft.com/v1.0/me/calendars
var calendar = new Calendar
{
    Name = "Volunteer",
};

var newCalendar = await graphClient.Me.Calendars
    .PostAsync(calendar);
```

## Other resources

- [Microsoft Graph REST API v1.0 reference](https://learn.microsoft.com/en-us/graph/api/overview)