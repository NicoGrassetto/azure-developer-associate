targetScope = 'subscription'

param location string = 'eastus'
param registryName string = 'myContainerRegistry'

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
