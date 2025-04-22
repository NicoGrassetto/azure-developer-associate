targetScope = 'subscription'

param location string = 'eastus'
// Updated registry name to include a unique suffix
param registryName string = 'myContainerRegistry${uniqueString(subscription().id)}'
param containerName string = 'mycontainer'
param dnsNameLabel string = 'aci-example-${uniqueString(subscription().id)}'
param imageName string = 'mcr.microsoft.com/azuredocs/aci-helloworld'
// Added secure parameter for API key
@secure()
param apiKey string = 'default-secure-api-key'

// ACR resource group
resource acrRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'az204-acr-rg'
  location: location
}

// ACI resource group
resource aciRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'az204-aci-rg'
  location: location
}

// Deploy Azure Container Registry
module acr 'acr.bicep' = {
  scope: acrRg
  name: 'acrDeploy'
  params: {
    location: location
    registryName: registryName
  }
}

// Deploy Azure Container Instance
module aci 'aci.bicep' = {
  scope: aciRg
  name: 'aciDeploy'
  params: {
    location: location
    containerName: containerName
    imageName: imageName
    dnsNameLabel: dnsNameLabel
    apiKey: apiKey
  }
}

// Output values
output registryName string = registryName
output containerFQDN string = aci.outputs.containerFQDN
