@description('Name of the Container Registry: cr{firstname}{lastname} (letters and numbers only)')
@minLength(5)
@maxLength(50)
param registryName string

@description('Name of the Log Analytics workspace: log-{firstname}-{lastname}')
param workspaceName string

@description('Name of the Container Apps Environment: cae-{firstname}-{lastname}')
param environmentName string

@description('Name of the Container App: ca-{firstname}-{lastname} (lowercase only)')
@maxLength(32)
param containerAppName string

@description('Container image to run')
param containerImage string

@description('Azure region')
param location string

@description('Name of the existing Service Bus namespace')
param serviceBusName string

@description('Queue the Container App reads from')
param queueName string

resource serviceBus 'Microsoft.ServiceBus/namespaces@2024-01-01' existing = {
  name: serviceBusName
}

resource rootRule 'Microsoft.ServiceBus/namespaces/authorizationRules@2024-01-01' existing = {
  parent: serviceBus
  name: 'RootManageSharedAccessKey'
}

resource registry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: registryName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true // no role assignments possible, so the app pulls with the admin credentials
  }
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource environment 'Microsoft.App/managedEnvironments@2025-01-01' = {
  name: environmentName
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: workspace.properties.customerId
        sharedKey: workspace.listKeys().primarySharedKey
      }
    }
    workloadProfiles: [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
    ]
  }
}

resource containerApp 'Microsoft.App/containerApps@2025-01-01' = {
  name: containerAppName
  location: location
  properties: {
    environmentId: environment.id
    workloadProfileName: 'Consumption'
    configuration: {
      activeRevisionsMode: 'Single'
      // No ingress: the app reads from a queue and receives no HTTP traffic
      secrets: [
        {
          name: 'servicebus-connection'
          value: rootRule.listKeys().primaryConnectionString
        }
        {
          name: 'registry-password'
          value: registry.listCredentials().passwords[0].value
        }
      ]
      registries: [
        {
          server: registry.properties.loginServer
          username: registry.listCredentials().username
          passwordSecretRef: 'registry-password'
        }
      ]
    }
    template: {
      containers: [
        {
          name: 'message-processor'
          image: containerImage
          resources: {
            cpu: json('0.25')
            memory: '0.5Gi'
          }
          env: [
            {
              name: 'ServiceBusConnection'
              secretRef: 'servicebus-connection'
            }
            {
              name: 'QueueName'
              value: queueName
            }
          ]
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 5
        rules: [
          {
            name: 'servicebus-queue'
            custom: {
              type: 'azure-servicebus'
              metadata: {
                queueName: queueName
                namespace: serviceBusName
                messageCount: '5'
              }
              auth: [
                {
                  secretRef: 'servicebus-connection'
                  triggerParameter: 'connection'
                }
              ]
            }
          }
        ]
      }
    }
  }
}

output registryLoginServer string = registry.properties.loginServer
