# Cloud computing

## Contents

1. [Overview](#1-overview)
2. [Computing in the cloud](#2-computing-in-the-cloud)
   - 2.1. [Key Benefits](#21-key-benefits)
   - 2.2. [Service Models](#22-service-models)
3. [Computing components in Azure](#3-computing-components-in-azure)
   - 3.1. [Azure Logic Apps](#31-azure-logic-apps)
   - 3.2. [Azure Function Apps](#32-azure-function-apps)
   - 3.3. [Azure Container Apps](#33-azure-container-apps)
     - 3.3.1. [Components Needed for Azure Container Apps](#331-components-needed-for-azure-container-apps)
   - 3.4. [Comparison: which service when](#34-comparison-which-service-when)
4. [Practical](#4-practical)
   - 4.1. [Overview](#41-overview)
   - 4.2. [Infrastructure as Code](#42-infrastructure-as-code)
   - 4.3. [Service Bus queues](#43-service-bus-queues)
   - 4.4. [Create Azure Logic App](#44-create-azure-logic-app)
     - 4.4.1. [Infrastructure](#441-infrastructure)
     - 4.4.2. [Workflow](#442-workflow)
   - 4.5. [Create Azure Function App](#45-create-azure-function-app)
     - 4.5.1. [Infrastructure](#451-infrastructure)
     - 4.5.2. [Function](#452-function)
   - 4.6. [Create Azure Container App](#46-create-azure-container-app)
     - 4.6.1. [Infrastructure](#461-infrastructure)
     - 4.6.2. [Application](#462-application)
5. [Solution](#5-solution)
   - 5.1. [Folder structure](#51-folder-structure)
   - 5.2. [GitHub Action and main.bicep](#52-github-action-and-mainbicep)
   - 5.3. [Logic App](#53-logic-app)
   - 5.4. [Function App](#54-function-app)
   - 5.5. [Container App](#55-container-app)
   - 5.6. [Run and verify](#56-run-and-verify)

## 1. Overview

Today, you'll gain an understanding of Cloud Computing, focusing on the Serverless and Container components available in Microsoft Azure.

The first part of the course will cover the high-level concepts of cloud computing and then dive deep into three powerful Azure services: Logic Apps (for low-code workflows), Function Apps (for event-driven code execution), and Container Apps (for managed microservices).

The second, practical part will unify these concepts by having you chain all three technologies into one serverless pipeline: a Logic App receives a message through an API endpoint and forwards it to an Azure Service Bus Queue, a Function App picks it up and enriches it, and a Container App processes the result. Building the Logic App (low-code) and the Function App (code-based) side by side will clearly demonstrate when and why you would choose one serverless service over another. You deploy all Azure resources for this pipeline with Infrastructure as Code (Bicep), building on the courses *Infrastructure as Code* and *Deploy Azure Resources*.

In short, you will move from theory to practical execution to master the diverse computing options Azure offers for building modern, scalable applications.

## 2. Computing in the cloud

Cloud computing is the on-demand delivery of IT resources—like computing power, storage, databases, and applications—over the internet with pay-as-you-go pricing. Instead of owning and managing physical data centers, you rent access to shared infrastructure from a cloud provider (like Microsoft Azure).

### 2.1. Key Benefits

**Cost-Effectiveness**: You only pay for the computing resources you use, eliminating the need for large capital expenditures on hardware.

**Scalability & Elasticity**: Resources can be scaled up or down instantly and automatically in response to demand.

**Global Reach**: Deploy applications close to users around the world via the provider's global network of data centers.

**Reliability & Security**: Cloud providers offer robust, redundant infrastructure and expert security measures.

### 2.2. Service Models

The cloud offers different models of abstraction:

**Infrastructure as a Service (IaaS):** You manage the operating system, middleware, and applications; the provider manages the hardware, networking, and virtualization. (Example: Azure Virtual Machines (VMs)).

**Platform as a Service (PaaS):** You manage only your application code and data; the provider manages the operating system, runtime, and all underlying infrastructure. (Example: Azure App Service, Azure Functions).

**Software as a Service (SaaS):** The provider manages everything, and you use the application as a service. (Example: Microsoft 365, Gmail).

## 3. Computing components in Azure

Azure offers a wide array of computing options to match different application needs, including:

| Category | Azure Service | Description | Good For |
|---|---|---|---|
| **IaaS** | **Virtual Machines (VMs)** | Full control over the operating system. | Migrating existing on-premises servers (lift-and-shift), custom OS or software requirements. |
| **PaaS** | **App Service** | Fully managed platform for hosting web apps, APIs, and mobile backends. | Traditional web applications (e.g., .NET, Java, Node.js). |
| **Serverless** | **Functions** | Event-driven compute, running code snippets on demand. | Executing small, reactive code blocks, background tasks, API backends. |
| **Serverless** | **Logic Apps** | Low-code/no-code, visual workflow designer. | Automating complex business processes, system-to-system integration. |
| **Container** | **Container Apps** | Managed environment for hosting microservices and containerized applications. | Modern microservices architectures, event-driven processing, Dapr services. |
| **Container** | **Kubernetes Service (AKS)** | Fully managed Kubernetes cluster for orchestration. | Complex microservices at enterprise scale, when deep Kubernetes control is needed. |

### 3.1. Azure Logic Apps

Azure Logic Apps is a serverless, low-code/no-code platform for building automated workflows. It uses a visual designer to connect services using pre-built connectors (for hundreds of services like SharePoint, Outlook, Salesforce, and Azure services).

It is ideal for business process automation and enterprise integration where the focus is on orchestrating a sequence of steps, data transformation, and connecting different systems.

### 3.2. Azure Function Apps

Azure Functions is a serverless compute service that allows you to run small blocks of code (called "functions") in response to events without managing the underlying infrastructure.

It is perfect for event-driven, short-running tasks where the primary focus is on executing code. It is "code-first."

### 3.3. Azure Container Apps

Azure Container Apps (ACA) is a fully managed serverless platform designed for hosting microservices and containerized applications. It runs your container images without requiring you to manage complex Kubernetes infrastructure. It supports advanced features like scaling based on HTTP traffic and events, and running Distributed Application Runtime (Dapr) services.

It is best suited for hosting modern applications built on containers/microservices that need features like:

- Automatic scale-to-zero (no cost when idle on the Consumption plan; this needs an HTTP- or event-based scale rule, CPU and memory rules can't scale to zero).
- Revision management (easy rollbacks).
- Event-driven processing from various sources (e.g., Kafka, Azure Service Bus).

#### 3.3.1. Components Needed for Azure Container Apps

| Component | Description |
|---|---|
| **Container App** | The core application unit. It runs one or more **containers** (typically a single application or microservice) based on a Docker image. |
| **Container** | The portable, executable unit of software built from a **Docker image**. It contains the application code, runtime, system tools, and libraries. |
| **Container Apps Environment** | A **secure boundary** that hosts one or more Container Apps. Apps within the same environment share the same logging workspace and network. |
| **Log Analytics Workspace (Optional)** | A workspace for **centralized logging and monitoring** for all Container Apps within the environment. All logs (container stdout/stderr, scaling events) are sent here. |
| **Virtual Network (VNet) (Optional)** | Can be used to connect the Container Apps Environment to other services in your private Azure network for isolation and security. |
| **Container Registry** | A service (like **Azure Container Registry - ACR** or Docker Hub) used to store and manage your private and public container images. The Container App pulls its image from here. |

### 3.4. Comparison: which service when

| Scenario | Best Choice | Reasoning |
|---|---|---|
| **Integrating 3rd-Party SaaS (e.g., "When a new item is in SharePoint, send a Slack message.")** | **Logic Apps** | Low-code, visual orchestration, hundreds of built-in connectors. |
| **Running a Small, Reactive Code Snippet (e.g., "Resize an image after upload.")** | **Function Apps** | Code-first, serverless compute, minimal operational overhead. |
| **Deploying a Microservice or API (e.g., A containerized e-commerce inventory service.)** | **Container Apps** | Managed container platform, easy scaling, ideal for modern app patterns. |

## 4. Practical

### 4.1. Overview

The practical segment of this course is designed to provide hands-on experience by building one serverless data pipeline with three different Azure computing technologies, chained together through Azure Service Bus queues.

**The Goal**: Create a complete, functioning, serverless data pipeline:

1. Input (Logic App): Receive an external message via a public HTTP POST request and send the full request body to an Azure Service Bus Queue.

2. Processing (Function App): Pick up the message from that queue, add the current timestamp and send it to a second queue.

3. Output (Container App): Pick up the message from the second queue and process it in a containerized application.

The Logic App and the Function App both create a process that moves a message through Service Bus: the Logic App low-code in a visual designer, the Function App code-based. Building both shows when and why you would choose one over the other.

### 4.2. Infrastructure as Code

In this practical part you don't create Azure resources by clicking in the Azure portal. You deploy **all Azure resources with Infrastructure as Code (Bicep)**, as you learned in the courses *Infrastructure as Code* and *Deploy Azure Resources*.

- Extend the GitHub repository from *Deploy Azure Resources*: add your new resources to its Bicep code and deploy them with your GitHub Action.
- Deploy everything to your own resource group `rg-{FirstName}-{Name}`, in region North Europe.
- Check every change with what-if before you deploy it.
- Every exercise starts with an **Infrastructure** part that lists exactly which resources, plans and settings you implement. Bicep deploys the *resources*; your workflow, function code and container image you build in the second part of each exercise.

Suggested structure of your repository:

```text
infra/
├── main.bicep              # Service Bus namespace + queues (4.3), calls the modules
└── modules/
    ├── logicapp.bicep      # 4.4
    ├── functionapp.bicep   # 4.5
    └── containerapp.bicep  # 4.6
```

> **REMARK:** You and your app registration have **Contributor** on your resource group. Contributor can't create role assignments, so you can't give a managed identity access to other resources. Many Bicep examples on Microsoft Learn use managed identities with role assignments: use **connection strings and keys** instead.

### 4.3. Service Bus queues

The three apps pass messages to each other through two queues in your existing Service Bus namespace `sb-{FirstName}-{Name}` from *Deploy Azure Resources*.

| Queue | Name | Sent by | Received by |
| --- | --- | --- | --- |
| First queue | `sbq-received` | Logic App (4.4) | Function App (4.5) |
| Second queue | `sbq-processed` | Function App (4.5) | Container App (4.6) |

1. Add both queues to your Bicep code, as child resources of your Service Bus namespace:

   info: <https://learn.microsoft.com/en-us/azure/templates/microsoft.servicebus/namespaces/queues?pivots=deployment-language-bicep>

   1. Names: `sbq-received` and `sbq-processed`
   2. Settings: default values
2. Deploy your Bicep code and check that both queues are visible in your Service Bus namespace.

> **REMARK:** All three apps connect to Service Bus with the connection string of your namespace. Don't copy it into your code: in Bicep you can read it from the namespace itself (look up `listKeys`).

### 4.4. Create Azure Logic App

![Logic apps](images/logic-apps-icon.png)

#### 4.4.1. Infrastructure

Add the Logic App to your Bicep code and deploy it.

info: <https://learn.microsoft.com/en-us/azure/logic-apps/quickstart-create-deploy-bicep>

| Resource | Setting | Value |
| --- | --- | --- |
| **Logic App** (`Microsoft.Logic/workflows`) | Name | `la-FirstName-LastName` |
| | Plan | **Consumption** |
| | Region | North Europe |
| | State | Enabled |
| | Workflow definition | Empty to start with: only the workflow schema, no trigger or actions |

> **REMARK:** A Consumption Logic App has no separate plan resource: the resource type `Microsoft.Logic/workflows` *is* the Consumption plan. A Logic App on the Standard plan uses a different resource type.

#### 4.4.2. Workflow

1. Create workflow in designer
   1. Make the workflow HTTP trigger
   2. Define your schema for the following body:

      ```json
      {"message": "Hello Service Bus"}
      ```

   3. Send the full request body to the queue `sbq-received`.
2. Copy your workflow from the code view into your Bicep code, so your next deployment doesn't overwrite it.
3. Test your Logic App and check that the message arrives in `sbq-received`.

> **REMARK:** A Logic App stores its workflow inside the resource itself. If your Bicep code only contains an empty workflow, every new deployment resets your workflow to empty and your designer work is gone. That is why step 2 matters: copy the complete code view, including the connection parameters.
>
> **Extra (optional):** the designer creates a Service Bus API connection (`Microsoft.Web/connections`) in your resource group. Add it to your Bicep code as well, so really everything is in code.

### 4.5. Create Azure Function App

#### 4.5.1. Infrastructure

Add the following resources to your Bicep code and deploy them. All resources: region North Europe.

info: <https://learn.microsoft.com/en-us/azure/azure-functions/functions-create-first-function-bicep>
(this example uses managed identities with role assignments, see the remark in 4.2)

| Resource | Setting | Value |
| --- | --- | --- |
| **Storage account** (`Microsoft.Storage/storageAccounts`) | Name | `stfunc` followed by `uniqueString(resourceGroup().id)` |
| | Kind / performance / redundancy | StorageV2 / Standard / LRS |
| | Blob container | `deployments`, for the deployment packages of your Function App |
| **App Service plan** (`Microsoft.Web/serverfarms`) | Name | `asp-FirstName-LastName` |
| | Plan | **Flex Consumption** (SKU `FC1`, tier `FlexConsumption`) |
| | Operating system | Linux |
| **Function App** (`Microsoft.Web/sites`) | Name | `func-FirstName-LastName` |
| | Kind | `functionapp,linux` |
| | Runtime | .NET isolated (`dotnet-isolated`), the same .NET version as your function project |
| | Instance memory | 2048 MB |
| | Maximum instance count | 10 |
| | Deployment storage | The `deployments` container, with authentication type *storage account connection string* |
| | App settings | `AzureWebJobsStorage`: connection string of the storage account |
| | | `DEPLOYMENT_STORAGE_CONNECTION_STRING`: connection string of the storage account |
| | | `ServiceBusConnection`: connection string of your Service Bus namespace |

#### 4.5.2. Function

1. Create an Azure Function:

   info: <https://learn.microsoft.com/en-us/azure/azure-functions/functions-develop-vs-code?tabs=node-v4%2Cpython-v2%2Cisolated-process%2Cquick-create&pivots=programming-language-csharp#create-an-azure-functions-project>
   (important for your prerequisites)

   1. Make the function (locally) so it can pick up messages from `sbq-received` (posted earlier by the Logic App), using the connection `ServiceBusConnection`
   2. Drop the picked up message in `sbq-processed`, but add the current timestamp to the message.
   3. Deploy your function to your Azure Function App
2. Test your Function App and check that the message, with its timestamp, arrives in `sbq-processed`.

### 4.6. Create Azure Container App

#### 4.6.1. Infrastructure

Add the following resources to your Bicep code and deploy them. All resources: region North Europe.

info: <https://learn.microsoft.com/en-us/azure/templates/microsoft.app/containerapps?pivots=deployment-language-bicep>
and <https://learn.microsoft.com/en-us/azure/container-apps/scale-app>

| Resource | Setting | Value |
| --- | --- | --- |
| **Container Registry** (`Microsoft.ContainerRegistry/registries`) | Name | `crfirstnamelastname` (letters and numbers only) |
| | Plan | **Basic** |
| | Admin user | Enabled: your Container App pulls images with these credentials (see the remark in 4.2) |
| **Log Analytics workspace** (`Microsoft.OperationalInsights/workspaces`) | Name | `log-firstname-lastname` |
| | Plan | Pay-as-you-go (`PerGB2018`), retention 30 days |
| **Container Apps Environment** (`Microsoft.App/managedEnvironments`) | Name | `cae-firstname-lastname` |
| | Plan | **Consumption** |
| | Logs | Sent to your Log Analytics workspace |
| **Container App** (`Microsoft.App/containerApps`) | Name | `ca-firstname-lastname` (lowercase only) |
| | Environment | `cae-firstname-lastname` |
| | Ingress | Disabled: the app reads from a queue and receives no HTTP traffic |
| | Revision mode | Single |
| | Image | `mcr.microsoft.com/k8se/quickstart:latest` to start with; your own image later (4.6.2) |
| | Registry | Your Container Registry, with its admin credentials |
| | CPU / memory | 0.25 vCPU / 0.5 GiB |
| | Secrets | Connection string of your Service Bus namespace, password of your Container Registry |
| | Environment variables | `ServiceBusConnection` (from the secret) and `QueueName` = `sbq-processed` |
| | Scale | Minimum 0 and maximum 5 replicas |
| | Scale rule | Custom rule of type `azure-servicebus` on the queue `sbq-processed`, authenticated with the Service Bus connection string |

> **REMARK:** Without ingress, the scale rule is the only thing that starts your app. If you leave it out, your Container App scales to zero and never starts again.

#### 4.6.2. Application

1. Create a container application:

   info: <https://learn.microsoft.com/en-us/azure/container-apps/quickstart-code-to-cloud>

   1. Make the application (locally) so it can pick up messages from `sbq-processed` (posted earlier by the Function App), using the environment variables `ServiceBusConnection` and `QueueName`
   2. Write the picked up message to the console, so it shows up in the logs of your Container App
   3. Create a Dockerfile, build your image and push it to your Container Registry
   4. Change the image in your Bicep code to your own image and deploy it
2. Test the full pipeline, from the Logic App to the Container App, and check that your Container App processes the message.

## 5. Solution

This chapter contains a working solution for chapter 4. Try it yourself first and only use this to check your work or when you are stuck. You can also find all files in the `Solution` folder of this course.

In all code below, replace `{FirstName}` and `{Name}` with your own name, in the same way as your resource group (ASCII only, e.g. `rg-Efrain-Mouton`). Names in lowercase use `{firstname}` and `{name}`.

### 5.1. Folder structure

The solution builds on your repository from *Deploy Azure Resources*:

```text
your-repository/
├── .github/
│   └── workflows/
│       └── deploy-infra.yml        # GitHub Action (4.2), replaces deploy-servicebus.yml
├── infra/
│   ├── main.bicep                  # Service Bus namespace + queues (4.3), calls the modules
│   └── modules/
│       ├── logicapp.bicep          # 4.4.1
│       ├── functionapp.bicep       # 4.5.1
│       └── containerapp.bicep      # 4.6.1
├── src/
│   ├── FunctionApp/                # Azure Function (4.5.2)
│   └── ContainerApp/               # Container application + Dockerfile (4.6.2)
├── test.http                       # Test message for the Logic App (REST Client)
├── .gitignore
└── README.md
```

> **REMARK:** Delete `deploy-servicebus.yml` from *Deploy Azure Resources*. Otherwise it also runs on every push, and fails, because `main.bicep` now needs your first and last name as parameters.

### 5.2. GitHub Action and main.bicep

File: `.github/workflows/deploy-infra.yml`

```yaml
name: Deploy infrastructure

on:
  push:
    branches: [main]
    paths:
      - 'infra/**'
      - '.github/workflows/deploy-infra.yml'
  workflow_dispatch:

permissions:
  contents: read

env:
  RESOURCE_GROUP: rg-{FirstName}-{Name}        # your own resource group
  SERVICE_BUS_NAME: sb-{FirstName}-{Name}      # your Service Bus namespace from Deploy Azure Resources
  FIRST_NAME: '{FirstName}'                    # used in the names of all resources
  LAST_NAME: '{Name}'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Log in to Azure
        uses: azure/login@v2
        with:
          creds: ${{ format('{{"clientId":"{0}","clientSecret":"{1}","subscriptionId":"{2}","tenantId":"{3}"}}', secrets.AZURE_CLIENT_ID, secrets.AZURE_CLIENT_SECRET, secrets.AZURE_SUBSCRIPTION_ID, secrets.AZURE_TENANT_ID) }}

      - name: Preview changes (what-if)
        run: |
          az deployment group what-if \
            --resource-group "$RESOURCE_GROUP" \
            --template-file infra/main.bicep \
            --parameters serviceBusName="$SERVICE_BUS_NAME" firstName="$FIRST_NAME" lastName="$LAST_NAME"

      - name: Deploy Bicep
        run: |
          az deployment group create \
            --name "infra-${{ github.run_number }}" \
            --resource-group "$RESOURCE_GROUP" \
            --template-file infra/main.bicep \
            --parameters serviceBusName="$SERVICE_BUS_NAME" firstName="$FIRST_NAME" lastName="$LAST_NAME"
```

What changed compared to *Deploy Azure Resources*:

- `env`: `FIRST_NAME` and `LAST_NAME` are added. `main.bicep` uses them in the names of all resources.
- **Preview changes** and **Deploy Bicep** pass them to `main.bicep`, next to `serviceBusName`.
- The workflow still runs on every push that changes `infra/`, so every change to your Bicep code is deployed automatically.

File: `infra/main.bicep`

```bicep
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
```

What it does:

- `serviceBus`: your existing namespace from *Deploy Azure Resources*. It stays in the code, because your Bicep code describes the complete end state.
- `queueReceived` and `queueProcessed`: the two queues of 4.3, as child resources of the namespace.
- `module`: one module per app. The names are built from your first and last name; names that must be lowercase use `toLower()`.
- Passing `serviceBus.name` and the queue names to the modules makes them wait until the namespace and the queues exist.
- `containerAppImage`: the image of the Container App. You change the default value to your own image in 4.6.2 (see 5.5).

### 5.3. Logic App

File: `infra/modules/logicapp.bicep`

```bicep
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

// The Service Bus API connection the workflow uses (the "Extra" in 4.4.2)
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
    // Copied from the code view of the designer (4.4.2, step 2)
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
```

What it does:

- `rootRule` (`existing`): refers to the default shared access policy of your namespace, without deploying it. `rootRule.listKeys()` reads the connection string during the deployment, so it never appears in your code or in Git. The other modules use the same pattern.
- `serviceBusConnection`: the Service Bus API connection that the designer would otherwise create for you (the *Extra* in 4.4.2).
- `logicApp`: the Consumption Logic App, as it looks after step 2 of 4.4.2. The `definition` is the code view of the designer: the HTTP trigger with the schema of 4.4.2 and the action *Send message* to `sbq-received`. In `parameters`, the workflow is linked to the API connection with references instead of hard-coded IDs.

> **REMARK:** The code view of the designer is JSON. When you paste JSON into a Bicep file in VS Code, the Bicep extension can convert it to Bicep for you. Inside a Bicep string, a single quote is written as `\'`.

**Test (4.4.2, step 3):**

1. In the Azure portal, open your Logic App > **Logic app designer** > the trigger *When a HTTP request is received*, and copy the **HTTP URL**.
2. Paste the URL in `test.http` and click **Send Request** (REST Client extension). Or use PowerShell:

   ```powershell
   Invoke-RestMethod -Method Post -Uri "<HTTP URL of your trigger>" -ContentType "application/json" -Body '{"message": "Hello Service Bus"}'
   ```

3. The run under **Run history** of your Logic App succeeded, and the message is in `sbq-received`: Service Bus namespace > **Queues** > `sbq-received` > **Service Bus Explorer** > **Peek from start**.

### 5.4. Function App

File: `infra/modules/functionapp.bicep`

```bicep
@description('Name of the Function App: func-{FirstName}-{LastName}')
param functionAppName string

@description('Name of the Flex Consumption plan: asp-{FirstName}-{LastName}')
param planName string

@description('Name of the storage account of the Function App')
@minLength(3)
@maxLength(24)
param storageAccountName string

@description('Azure region')
param location string

@description('Name of the existing Service Bus namespace')
param serviceBusName string

var deploymentContainerName = 'deployments'

resource serviceBus 'Microsoft.ServiceBus/namespaces@2024-01-01' existing = {
  name: serviceBusName
}

resource rootRule 'Microsoft.ServiceBus/namespaces/authorizationRules@2024-01-01' existing = {
  parent: serviceBus
  name: 'RootManageSharedAccessKey'
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-06-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2025-06-01' = {
  parent: storageAccount
  name: 'default'
}

resource deploymentContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-06-01' = {
  parent: blobService
  name: deploymentContainerName
}

resource plan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: planName
  location: location
  kind: 'functionapp'
  sku: {
    name: 'FC1'
    tier: 'FlexConsumption'
  }
  properties: {
    reserved: true // Linux
  }
}

// Connection string instead of a managed identity: Contributor can't create role assignments
var storageConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'

resource functionApp 'Microsoft.Web/sites@2024-11-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp,linux'
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: storageConnectionString
        }
        {
          name: 'DEPLOYMENT_STORAGE_CONNECTION_STRING'
          value: storageConnectionString
        }
        {
          name: 'ServiceBusConnection'
          value: rootRule.listKeys().primaryConnectionString
        }
      ]
    }
    functionAppConfig: {
      deployment: {
        storage: {
          type: 'blobContainer'
          value: '${storageAccount.properties.primaryEndpoints.blob}${deploymentContainer.name}'
          authentication: {
            type: 'StorageAccountConnectionString'
            storageAccountConnectionStringName: 'DEPLOYMENT_STORAGE_CONNECTION_STRING'
          }
        }
      }
      scaleAndConcurrency: {
        instanceMemoryMB: 2048
        maximumInstanceCount: 10
      }
      runtime: {
        name: 'dotnet-isolated'
        version: '10.0'
      }
    }
  }
}
```

What it does:

- `storageAccount` and `deploymentContainer`: the storage a Function App needs, for its own state (`AzureWebJobsStorage`) and for its deployment packages (container `deployments`).
- `plan`: the Flex Consumption plan (SKU `FC1`, Linux).
- `functionApp`: .NET 10 isolated, instances of 2048 MB, at most 10 instances. The deployment storage and `AzureWebJobsStorage` use the connection string of the storage account (built with `listKeys()`) instead of a managed identity, see 4.2. `ServiceBusConnection` holds the connection string the function uses.

File: `src/FunctionApp/AddTimestamp.cs`

```csharp
using System.Text.Json;
using System.Text.Json.Nodes;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace FunctionApp;

public class AddTimestamp(ILogger<AddTimestamp> logger)
{
    // Picks up a message from sbq-received, adds the current timestamp
    // and sends the result to sbq-processed (4.5.2).
    [Function(nameof(AddTimestamp))]
    [ServiceBusOutput("sbq-processed", Connection = "ServiceBusConnection")]
    public string Run(
        [ServiceBusTrigger("sbq-received", Connection = "ServiceBusConnection")] string message)
    {
        JsonObject body;
        try
        {
            body = JsonNode.Parse(message) as JsonObject ?? new JsonObject { ["message"] = message };
        }
        catch (JsonException)
        {
            // Not JSON: wrap the plain text
            body = new JsonObject { ["message"] = message };
        }

        body["timestamp"] = DateTime.UtcNow.ToString("o");

        logger.LogInformation("Forwarding message to sbq-processed: {Body}", body.ToJsonString());
        return body.ToJsonString();
    }
}
```

What it does:

- `ServiceBusTrigger`: runs for every message on `sbq-received`, with the connection string from the app setting `ServiceBusConnection`.
- Reads the body as JSON (plain text is wrapped in a `message` property) and adds `timestamp` in ISO 8601 format.
- `ServiceBusOutput`: the return value is sent to `sbq-processed`.

The other files in `src/FunctionApp` (`FunctionApp.csproj`, `Program.cs`, `host.json`) are the standard files of a .NET isolated function project.

**Run locally and deploy:**

```bash
cd src/FunctionApp

# Run locally: copy the example settings and fill in the connection string of your Service Bus namespace
cp local.settings.example.json local.settings.json
func start

# Deploy to your Function App (or in VS Code: Azure Functions: Deploy to Function App...)
func azure functionapp publish func-{FirstName}-{Name}
```

> **REMARK:** A function with a non-HTTP trigger also needs storage when it runs locally. With `UseDevelopmentStorage=true`, start **Azurite** first (VS Code: *Azurite: Start*). Never commit `local.settings.json`: it contains your connection string. The `.gitignore` of the solution excludes it.

**Test (4.5.2, step 2):** send a new message with `test.http`. A few seconds later the message is in `sbq-processed`, with a `timestamp`:

```json
{"message":"Hello Service Bus","timestamp":"2026-10-23T10:15:30.1234567Z"}
```

### 5.5. Container App

File: `infra/modules/containerapp.bicep`

```bicep
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
```

What it does:

- `registry`: Basic Container Registry with the admin user enabled. `registry.listCredentials()` supplies the username and password the Container App uses to pull your image.
- `workspace` and `environment`: the Container Apps Environment on the Consumption plan, sending its logs to the Log Analytics workspace.
- `containerApp`: no ingress, single revision mode, 0.25 vCPU and 0.5 GiB. The Service Bus connection string and the registry password are stored as **secrets**; the app reads the connection string and queue name from **environment variables**.
- `scale`: 0 to 5 replicas. The `azure-servicebus` rule checks `sbq-processed` and starts a replica as soon as there is a message; `messageCount` is the number of messages per replica before an extra replica is added.

File: `src/ContainerApp/Program.cs`

```csharp
using System.Runtime.InteropServices;
using Azure.Messaging.ServiceBus;

// Settings from the environment variables of the Container App (4.6.1)
var connectionString = Environment.GetEnvironmentVariable("ServiceBusConnection")
    ?? throw new InvalidOperationException("Environment variable ServiceBusConnection is not set.");
var queueName = Environment.GetEnvironmentVariable("QueueName") ?? "sbq-processed";

await using var client = new ServiceBusClient(connectionString);
await using var processor = client.CreateProcessor(queueName);

// Write every message to the console, so it shows up in the logs (4.6.2).
// The processor completes the message automatically when this handler succeeds.
processor.ProcessMessageAsync += args =>
{
    Console.WriteLine($"Received message {args.Message.MessageId}: {args.Message.Body}");
    return Task.CompletedTask;
};

processor.ProcessErrorAsync += args =>
{
    Console.Error.WriteLine($"Error from {args.ErrorSource}: {args.Exception.Message}");
    return Task.CompletedTask;
};

// Stop cleanly when the Container App scales in (SIGTERM) or on Ctrl+C locally (SIGINT)
using var shutdown = new CancellationTokenSource();
using var onSigterm = PosixSignalRegistration.Create(PosixSignal.SIGTERM, context => { context.Cancel = true; shutdown.Cancel(); });
using var onSigint = PosixSignalRegistration.Create(PosixSignal.SIGINT, context => { context.Cancel = true; shutdown.Cancel(); });

await processor.StartProcessingAsync();
Console.WriteLine($"Listening for messages on queue {queueName}...");

try
{
    await Task.Delay(Timeout.Infinite, shutdown.Token);
}
catch (TaskCanceledException)
{
    // Shutdown requested
}

await processor.StopProcessingAsync();
Console.WriteLine("Stopped.");
```

What it does:

- Reads `ServiceBusConnection` and `QueueName` from the environment variables of the Container App.
- A `ServiceBusProcessor` writes every message to the console and then completes it, so it is removed from the queue.
- Stops cleanly when the Container App scales in (`SIGTERM`).

File: `src/ContainerApp/Dockerfile`

```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY ContainerApp.csproj .
RUN dotnet restore
COPY . .
RUN dotnet publish --configuration Release --output /app --no-restore

FROM mcr.microsoft.com/dotnet/runtime:10.0
WORKDIR /app
COPY --from=build /app .
USER $APP_UID
ENTRYPOINT ["dotnet", "ContainerApp.dll"]
```

What it does: builds the app with the .NET SDK image, then copies the result to the much smaller .NET runtime image, which runs as the non-root user `app`.

**Build, push and deploy (4.6.2, steps 3 and 4):**

```bash
# Build your image and push it to your Container Registry (Docker must be running)
az acr login --name cr{firstname}{name}
docker build --platform linux/amd64 -t cr{firstname}{name}.azurecr.io/message-processor:v1 src/ContainerApp
docker push cr{firstname}{name}.azurecr.io/message-processor:v1
```

Then change the default value of `containerAppImage` in `infra/main.bicep`, and commit and push. The GitHub Action deploys a new revision with your image:

```bicep
param containerAppImage string = 'cr{firstname}{name}.azurecr.io/message-processor:v1'
```

> **REMARK:** Use a new tag (`v2`, `v3`, ...) for every new image. If you push a new image with the same tag, your Bicep code doesn't change, so no new revision is deployed.

**Test (4.6.2, step 2):** send a new message with `test.http`. Within about 30 seconds the scale rule starts a replica, and the message appears in the logs: Container App > **Monitoring** > **Log stream** (while a replica is running), or **Monitoring** > **Logs**:

```kusto
ContainerAppConsoleLogs_CL
| where ContainerAppName_s == 'ca-{firstname}-{name}'
| project TimeGenerated, Log_s
| order by TimeGenerated desc
```

Logs can take a few minutes to appear in Log Analytics. About 5 minutes after the last message, the Container App scales back to zero.

### 5.6. Run and verify

1. Commit and push. When the GitHub Action is green, your resource group contains:

   | App | Resources |
   | --- | --- |
   | **Service Bus** | `sb-{FirstName}-{Name}` with the queues `sbq-received` and `sbq-processed` |
   | **Logic App** | `la-{FirstName}-{Name}`, API connection `servicebus-la-{FirstName}-{Name}` |
   | **Function App** | `func-{FirstName}-{Name}`, plan `asp-{FirstName}-{Name}`, storage account `stfunc...` |
   | **Container App** | `ca-{firstname}-{name}`, environment `cae-{firstname}-{name}`, registry `cr{firstname}{name}`, workspace `log-{firstname}-{name}` |

2. Test the Logic App (5.3): the message arrives in `sbq-received`.
3. Deploy the function and test again (5.4): the message moves to `sbq-processed`, with a timestamp.
4. Push your container image and deploy it (5.5).
5. Test the full pipeline: one message sent to the Logic App ends up in the logs of your Container App, with its timestamp.

Common errors:

| Error | Cause | Fix |
| --- | --- | --- |
| `AuthorizationFailed` for `Microsoft.Authorization/roleAssignments/write` | Your Bicep code creates role assignments, e.g. copied from a Microsoft Learn example with managed identities | Remove the role assignments and use connection strings (4.2) |
| Old workflow fails with a missing parameter `firstName` | `deploy-servicebus.yml` still runs next to `deploy-infra.yml` | Delete `deploy-servicebus.yml` (5.1) |
| Logic App workflow is empty again after a deployment | The workflow from the designer isn't in your Bicep code | Copy the code view into your Bicep code (4.4.2, step 2) |
| Messages stay in `sbq-received` | The function isn't deployed, or the app setting `ServiceBusConnection` is missing | Deploy the function and check **Settings > Environment variables** of your Function App |
| Messages stay in `sbq-processed` and no replica starts | The scale rule is missing or its connection secret is wrong | Check **Application > Scale** of your Container App |
| Revision fails with an image pull error | Wrong image name, or the registry credentials are missing | Check the image name and tag, and the registry under **Settings > Registries** |
| Name is invalid or too long | Container App names are max. 32 characters, lowercase; registry names only letters and numbers | Shorten your names, e.g. `ca-jdewilde` |
