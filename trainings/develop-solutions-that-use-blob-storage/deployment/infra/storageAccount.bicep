@description('The name of the storage account to be created.')
param storageAccountName string

@description('The location of the resources')
param location string = resourceGroup().location

@description('The SKU of the storage account to be created.')
@allowed(['Standard_LRS', 'Standard_GRS', 'Standard_ZRS', 'Premium_LRS'])
param skuName string = 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

module blobStorage './blobStorage.bicep' = {
  name: 'blobStorageModule'
  params: {
    storageAccountName: storageAccountName
    location: location
    skuName: skuName
  }
}

// Outputs
output storageAccountName string = storageAccount.name
output storageAccountId string = storageAccount.id
output storageAccountKey string = listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value
output storageAccountConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
