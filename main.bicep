@description('Name of the Service Bus namespace: sb-{Nathan}-{Amerlynck}')
@minLength(6)
@maxLength(50)
param serviceBusName string
@description('Azure region for the Service Bus namespace')
param location string = 'northeurope'
resource serviceBus 'Microsoft.ServiceBus/namespaces@2024-01-01' = {
name: serviceBusName
location: location
sku: {
name: 'Basic'
tier: 'Basic'
}
properties: {
minimumTlsVersion: '1.2'
}
}
output serviceBusId string = serviceBus.id
output serviceBusEndpoint string = serviceBus.properties.serviceBusEndpoint
//