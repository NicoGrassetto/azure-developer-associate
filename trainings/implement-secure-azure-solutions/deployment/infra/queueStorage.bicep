// filepath: /Users/nicograssetto/Documents/GitHub/notes/azure-developer-associate/queueStorage.bicep
@description('The name of the storage account where the queue will be created')
param storageAccountName string

@description('The location of the resources')
param location string = resourceGroup().location

@description('The name of the queue to create')
param queueName string

@description('The SKU of the storage account')
@allowed(['Standard_LRS', 'Standard_GRS', 'Standard_ZRS', 'Premium_LRS'])
param skuName string = 'Standard_LRS'

// Reference the existing storage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName
}

// Create the queue service
resource queueService 'Microsoft.Storage/storageAccounts/queueServices@2021-09-01' = {
  parent: storageAccount
  name: 'default'
  properties: {}
}

// Create the queue
resource queue 'Microsoft.Storage/storageAccounts/queueServices/queues@2021-09-01' = {
  parent: queueService
  name: queueName
  properties: {
    metadata: {}
  }
}

// Output the queue URL and name
output queueName string = queue.name
output queueUrl string = '${storageAccount.properties.primaryEndpoints.queue}${queueName}'
