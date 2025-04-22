targetScope = 'subscription'

param location string = 'eastus'
// Updated registry name to include a unique suffix
param registryName string = 'myContainerRegistry${uniqueString(subscription().id)}'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'az204-acr-rg'
  location: location
}

module acr 'acr.bicep' = {
  scope: rg
  name: 'acrDeploy'
  params: {
    location: location
    registryName: registryName
  }
}
