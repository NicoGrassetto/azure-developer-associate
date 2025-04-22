param location string
param containerName string
param imageName string
param dnsNameLabel string
param cpu int = 1
param memory int = 1
// Added parameter for API key as secure string
@secure()
param apiKey string = 'default-secure-api-key'

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: containerName
  location: location
  properties: {
    containers: [
      {
        name: containerName
        properties: {
          image: imageName
          resources: {
            requests: {
              cpu: cpu
              memoryInGB: memory
            }
          }
          ports: [
            {
              port: 80
              protocol: 'TCP'
            }
          ]
          environmentVariables: [
            {
              name: 'numWords'
              value: '5'
            }
            {
              name: 'MinLength'
              value: '8'
            }
            {
              name: 'API_KEY'
              secureValue: apiKey
            }
          ]
        }
      }
    ]
    osType: 'Linux'
    restartPolicy: 'OnFailure'
    ipAddress: {
      type: 'Public'
      dnsNameLabel: dnsNameLabel
      ports: [
        {
          port: 80
          protocol: 'TCP'
        }
      ]
    }
  }
}

output containerFQDN string = containerGroup.properties.ipAddress.fqdn
