@description('Name of the Logic App: la-{FirstName}-{LastName}')
param logicAppName string

@description('Azure region')
param location string

@description('Name of the existing Service Bus namespace')
param serviceBusName string

@description('Queue the Logic App sends to')
param queueName string

resource serviceBus 'Microsoft.ServiceBus/namespaces@2024-01-01' existing = {
  name: serviceBusName
}

resource rootRule 'Microsoft.ServiceBus/namespaces/authorizationRules@2024-01-01' existing = {
  parent: serviceBus
  name: 'RootManageSharedAccessKey'
}

// The Service Bus API connection the workflow uses
resource serviceBusConnection 'Microsoft.Web/connections@2016-06-01' = {
  name: 'servicebus-${logicAppName}'
  location: location
  properties: {
    displayName: 'Service Bus ${serviceBusName}'
    api: {
      id: subscriptionResourceId('Microsoft.Web/locations/managedApis', location, 'servicebus')
    }
    parameterValues: {
      connectionString: rootRule.listKeys().primaryConnectionString
    }
  }
}

// Consumption plan: the resource type Microsoft.Logic/workflows is the plan
resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        When_a_HTTP_request_is_received: {
          type: 'Request'
          kind: 'Http'
          inputs: {
            method: 'POST'
            schema: {
              type: 'object'
              properties: {
                message: {
                  type: 'string'
                }
              }
            }
          }
        }
      }
      actions: {
        Send_message: {
          type: 'ApiConnection'
          runAfter: {}
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'servicebus\'][\'connectionId\']'
              }
            }
            method: 'post'
            path: '/@{encodeURIComponent(encodeURIComponent(\'${queueName}\'))}/messages'
            body: {
              ContentData: '@{base64(triggerBody())}'
              ContentType: 'application/json'
            }
            queries: {
              systemProperties: 'None'
            }
          }
        }
      }
      outputs: {}
    }
    parameters: {
      '$connections': {
        value: {
          servicebus: {
            connectionId: serviceBusConnection.id
            connectionName: serviceBusConnection.name
            id: serviceBusConnection.properties.api.id
          }
        }
      }
    }
  }
}
