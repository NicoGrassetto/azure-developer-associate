@description('Name of the Service Bus namespace')
param namespaceName string

@description('Location for all resources.')
param location string

@description('Name of the Service Bus queue')
param queueName string = 'az204-queue'

@allowed([
  'Basic'
  'Standard'
  'Premium'
])
@description('The messaging tier for Service Bus namespace')
param skuName string = 'Standard'

@description('The pricing tier of this Service Bus namespace')
param skuTier string = 'Standard'

@description('The maximum size of the queue in megabytes')
param maxSizeInMegabytes int = 1024

@description('A value indicating if this queue requires duplicate detection')
param requiresDuplicateDetection bool = false

@description('ISO 8601 default message timespan to live value')
param defaultMessageTimeToLive string = 'P14D'

@description('Value that indicates whether server-side batched operations are enabled')
param enableBatchedOperations bool = true

@description('ISO 8601 timeSpan structure that defines the duration of the duplicate detection history')
param duplicateDetectionHistoryTimeWindow string = 'PT10M'

@description('A value that indicates whether this queue supports sessions')
param requiresSession bool = false

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-01-01-preview' = {
  name: namespaceName
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {}
}

resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2022-01-01-preview' = {
  parent: serviceBusNamespace
  name: queueName
  properties: {
    lockDuration: 'PT1M'
    maxSizeInMegabytes: maxSizeInMegabytes
    requiresDuplicateDetection: requiresDuplicateDetection
    requiresSession: requiresSession
    defaultMessageTimeToLive: defaultMessageTimeToLive
    deadLetteringOnMessageExpiration: false
    duplicateDetectionHistoryTimeWindow: duplicateDetectionHistoryTimeWindow
    maxDeliveryCount: 10
    enableBatchedOperations: enableBatchedOperations
    status: 'Active'
  }
}

// Create a Shared Access Policy for the namespace that can be used for sending and listening
resource serviceBusNamespaceAuthRule 'Microsoft.ServiceBus/namespaces/AuthorizationRules@2022-01-01-preview' = {
  name: 'RootManageSharedAccessKey'
  parent: serviceBusNamespace
  properties: {
    rights: [
      'Listen'
      'Send'
      'Manage'
    ]
  }
}

// Output the connection string that can be used in the Python script
output serviceBusConnectionString string = listKeys(serviceBusNamespaceAuthRule.id, serviceBusNamespaceAuthRule.apiVersion).primaryConnectionString
output serviceBusName string = serviceBusNamespace.name
output queueName string = serviceBusQueue.name
