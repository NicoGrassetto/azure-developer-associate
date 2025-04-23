# Implement secure Azure solutions

| SDK | Sample |
|-----|---------|
| .NET | [Manage resource from a virtual machine enabled with managed identities for Azure resources enabled](https://github.com/Azure-Samples/aad-dotnet-manage-resources-from-vm-with-msi) |
| Java | [Manage storage from a virtual machine enabled with managed identities for Azure resources](https://github.com/Azure-Samples/compute-java-manage-resources-from-vm-with-msi-in-aad-group) |
| Node.js | [Create a virtual machine with system-assigned managed identity enabled](https://github.com/Azure-Samples/compute-node-msi-vm) |
| Python | [Create a virtual machine with system-assigned managed identity enabled](https://learn.microsoft.com/en-us/azure/developer/python/sdk/examples/azure-sdk-example-virtual-machines?tabs=cmd) |
| Ruby | [Create Azure virtual machine with an system-assigned identity enabled](https://github.com/Azure-Samples/compute-ruby-msi-vm/) |


### Acquire an access token

A client application can request managed identities for Azure resources app-only access token for accessing a given resource. The token is based on the managed identities for Azure resources service principal. The recommended method is to use the `DefaultAzureCredential`.

The Azure Identity library supports a `DefaultAzureCredential` type. `DefaultAzureCredential` automatically attempts to authenticate via multiple mechanisms, including environment variables or an interactive sign-in. The credential type can be used in your development environment using your own credentials. It can also be used in your production Azure environment using a managed identity. No code changes are required when you deploy your application.

> **Note**: `DefaultAzureCredential` is intended to simplify getting started with the SDK by handling common scenarios with reasonable default behaviors. Developers who want more control or whose scenario isn't served by the default settings should use other credential types.

The `DefaultAzureCredential` attempts to authenticate via the following mechanisms, in this order, stopping when one succeeds:

- **Environment** - The `DefaultAzureCredential` reads account information specified via environment variables and use it to authenticate.
- **Managed Identity** - If the application is deployed to an Azure host with Managed Identity enabled, the `DefaultAzureCredential` authenticates with that account.
- **Visual Studio** - If the developer authenticated via Visual Studio, the `DefaultAzureCredential` authenticates with that account.
- **Azure CLI** - If the developer authenticated an account via the Azure CLI `az login` command, the `DefaultAzureCredential` authenticates with that account. Visual Studio Code users can authenticate their development environment using the Azure CLI.
- **Azure PowerShell** - If the developer authenticated an account via the Azure PowerShell `Connect-AzAccount` command, the `DefaultAzureCredential` authenticates with that account.
- **Interactive browser**- If enabled, the `DefaultAzureCredential` interactively authenticates the developer via the current system's default browser. By default, this credential type is disabled.

#### Examples

The following examples use the Azure Identity SDK that can be added to a project with this command:


##### Authenticate with `DefaultAzureCredential`
This example demonstrates authenticating the `SecretClient` from the `azure-keyvault-secrets` client library using the `DefaultAzureCredential`.

```python
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

# Create a secret client using the DefaultAzureCredential
credential = DefaultAzureCredential()
client = SecretClient(vault_url="https://myvault.vault.azure.net/", credential=credential)
```

#### Specify a user-assigned managed identity with `DefaultAzureCredential`

This example demonstrates configuring the `DefaultAzureCredential` to authenticate a user-assigned identity when deployed to an Azure host. It then authenticates a `BlobClient` from the `azure-storage-blob` client library with the credential.

```python
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobClient

# When deployed to an azure host, the default azure credential will authenticate the specified user assigned managed identity.
user_assigned_client_id = "<your managed identity client Id>"
credential = DefaultAzureCredential(managed_identity_client_id=user_assigned_client_id)

blob_client = BlobClient(account_url="https://myaccount.blob.core.windows.net/", container_name="mycontainer", blob_name="myblob", credential=credential)
```

#### Define a custom authentication flow with `ChainedTokenCredential`

This example demonstrates creating a `ChainedTokenCredential` which attempts to authenticate using managed identity, and falls back to authenticating via the Azure CLI if managed identity is unavailable in the current environment. The credential is then used to authenticate an `EventHubProducerClient` from the `azure-messaging-eventhubs` client library.

```python
from azure.identity import ChainedTokenCredential, ManagedIdentityCredential, AzureCliCredential
from azure.eventhub import EventHubProducerClient

# Authenticate using managed identity if it is available; otherwise use the Azure CLI to authenticate.
credential = ChainedTokenCredential(ManagedIdentityCredential(), AzureCliCredential())

event_hub_producer_client = EventHubProducerClient(fully_qualified_namespace="myeventhub.eventhubs.windows.net", eventhub_name="myhubpath", credential=credential)
```
