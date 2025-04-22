targetScope = 'subscription'

param location string = 'eastus'  // Change this to your preferred location

resource rg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: 'az204-acr-rg'
  location: location
}
