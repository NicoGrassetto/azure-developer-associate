// Main deployment file for Azure resources

// Common parameters
@description('The Azure region for deploying resources')
param location string = resourceGroup().location

@description('Environment name (dev, test, prod)')
param environment string = 'dev'

// Service Bus parameters
@description('Name of the Service Bus namespace')
param serviceBusNamespaceName string = 'servicebus${uniqueString(resourceGroup().id)}'

@description('Name of the Service Bus queue')
param serviceBusQueueName string = 'az204-queue'

// Storage Account parameters
@description('Name of the storage account')
param storageAccountName string = 'storage${uniqueString(resourceGroup().id)}'

// Storage Queue parameters
@description('Name of the storage queue')
param storageQueueName string = 'az204-storagequeue'

// Key Vault parameters
@description('Name of the key vault')
param keyVaultName string = 'kv${uniqueString(resourceGroup().id)}'

// Deploy Service Bus
module serviceBusModule './serviceBus.bicep' = {
  name: 'serviceBusDeploy'
  params: {
    namespaceName: serviceBusNamespaceName
    location: location
    queueName: serviceBusQueueName
  }
}

// Deploy Storage Account (which includes Blob Storage)
module storageAccountModule './storageAccount.bicep' = {
  name: 'storageAccountDeploy'
  params: {
    storageAccountName: storageAccountName
    location: location
  }
}

// Deploy Storage Queue
module storageQueueModule './queueStorage.bicep' = {
  name: 'storageQueueDeploy'
  params: {
    storageAccountName: storageAccountName
    location: location
    queueName: storageQueueName
  }
  dependsOn: [
    storageAccountModule
  ]
}

// Deploy Key Vault
module keyVaultModule './keyVault.bicep' = {
  name: 'keyVaultDeploy'
  params: {
    vaultName: keyVaultName
    location: location
  }
}

// Outputs
output serviceBusConnectionString string = serviceBusModule.outputs.serviceBusConnectionString
output serviceBusName string = serviceBusModule.outputs.serviceBusName
output serviceBusQueueName string = serviceBusModule.outputs.queueName
output storageAccountConnectionString string = storageAccountModule.outputs.storageAccountConnectionString
output storageQueueName string = storageQueueModule.outputs.queueName
output storageQueueUrl string = storageQueueModule.outputs.queueUrl
