@description('Your first name, as in your resource group rg-{FirstName}-{Name} (ASCII only)')
@minLength(2)
param firstName string

@description('Your last name, as in your resource group rg-{FirstName}-{Name} (ASCII only)')
@minLength(2)
param lastName string

@description('Name of your Service Bus namespace from Deploy Azure Resources: sb-{FirstName}-{Name}')
@minLength(6)
@maxLength(50)
param serviceBusName string

@description('Azure region for all resources')
param location string = 'northeurope'

@description('Image of the Container App: the quickstart image first, your own image after 4.6.2')
param containerAppImage string = 'mcr.microsoft.com/k8se/quickstart:latest'

// Service Bus namespace (Deploy Azure Resources) and its queues (4.3)
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

resource queueReceived 'Microsoft.ServiceBus/namespaces/queues@2024-01-01' = {
  parent: serviceBus
  name: 'sbq-received'
}

resource queueProcessed 'Microsoft.ServiceBus/namespaces/queues@2024-01-01' = {
  parent: serviceBus
  name: 'sbq-processed'
}

// 4.4: Logic App
module logicApp 'modules/logicapp.bicep' = {
  name: 'logicapp'
  params: {
    logicAppName: 'la-${firstName}-${lastName}'
    location: location
    serviceBusName: serviceBus.name
    queueName: queueReceived.name
  }
}

// 4.5: Function App
module functionApp 'modules/functionapp.bicep' = {
  name: 'functionapp'
  params: {
    functionAppName: 'func-${firstName}-${lastName}'
    planName: 'asp-${firstName}-${lastName}'
    storageAccountName: 'stfunc${uniqueString(resourceGroup().id)}'
    location: location
    serviceBusName: serviceBus.name
  }
}

// 4.6: Container App
module containerApp 'modules/containerapp.bicep' = {
  name: 'containerapp'
  params: {
    registryName: toLower('cr${firstName}${lastName}')
    workspaceName: toLower('log-${firstName}-${lastName}')
    environmentName: toLower('cae-${firstName}-${lastName}')
    containerAppName: toLower('ca-${firstName}-${lastName}')
    containerImage: containerAppImage
    location: location
    serviceBusName: serviceBus.name
    queueName: queueProcessed.name
  }
}

output serviceBusEndpoint string = serviceBus.properties.serviceBusEndpoint
output registryLoginServer string = containerApp.outputs.registryLoginServer
