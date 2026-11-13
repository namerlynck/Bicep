# Infrastructure as Code

## Contents

1. [Objectives](#1-objectives)
2. [What is Infrastructure as Code](#2-what-is-infrastructure-as-code)
   - 2.1. [The problem with manual infrastructure](#21-the-problem-with-manual-infrastructure)
   - 2.2. [Definition](#22-definition)
   - 2.3. [Declarative vs imperative](#23-declarative-vs-imperative)
   - 2.4. [Key benefits](#24-key-benefits)
   - 2.5. [Challenges and good practices](#25-challenges-and-good-practices)
3. [Infrastructure as Code on Azure](#3-infrastructure-as-code-on-azure)
   - 3.1. [Azure Resource Manager](#31-azure-resource-manager)
   - 3.2. [IaC languages for Azure](#32-iac-languages-for-azure)
   - 3.3. [Bicep in a nutshell](#33-bicep-in-a-nutshell)
   - 3.4. [Deployments](#34-deployments)
4. [What you need](#4-what-you-need)
   - 4.1. [Azure](#41-azure)
   - 4.2. [Local tooling](#42-local-tooling)
   - 4.3. [Automation](#43-automation)
5. [Exercise: Deploy a storage account with Bicep](#5-exercise-deploy-a-storage-account-with-bicep)
   - 5.1. [Prepare your environment](#51-prepare-your-environment)
   - 5.2. [Write your Bicep file](#52-write-your-bicep-file)
   - 5.3. [Preview and deploy](#53-preview-and-deploy)
   - 5.4. [Change and redeploy](#54-change-and-redeploy)
   - 5.5. [Extra: detect drift (optional)](#55-extra-detect-drift-optional)
6. [Solution](#6-solution)
   - 6.1. [main.bicep](#61-mainbicep)
   - 6.2. [Commands](#62-commands)
   - 6.3. [Run and verify](#63-run-and-verify)

---

## 1. Objectives

Students will learn what Infrastructure as Code (IaC) is, why it has become the standard way to build cloud environments, and how it works on Microsoft Azure with Bicep. After the theory, you write your first Bicep file and deploy an Azure resource from your own laptop.

In the course *Deploy Azure Resources* you take the next step: you automate such a deployment with a CI/CD pipeline in GitHub Actions.

## 2. What is Infrastructure as Code

### 2.1. The problem with manual infrastructure

In the course *Deploy Azure Resources* you create a storage account by clicking through the Azure portal. For one resource that works fine, but a real project looks different:

- An application needs many resources: Function Apps, a Service Bus, storage accounts, databases, networking, monitoring, ...
- The same setup is needed several times: a **development**, a **test** and a **production** environment.
- Several people make changes over months or years, and nobody remembers exactly which settings were chosen, or why.

Building all of this by hand in the portal (often called *ClickOps*) leads to environments that slowly differ from each other, configuration that nobody can reproduce, and mistakes that are hard to trace.

### 2.2. Definition

Infrastructure as Code means that you **describe your infrastructure in code files** instead of creating it by hand. You write down which resources you need and with which settings. A tool reads those files and makes your cloud environment match them.

> "Treat your infrastructure like your application code: write it, version it, review it and deploy it automatically."

Because your infrastructure is now code, you can use the same tools as for application code: Git, pull requests, code reviews and CI/CD pipelines.

### 2.3. Declarative vs imperative

There are two ways to automate infrastructure:

| Approach | You describe | Example | Running it twice |
| --- | --- | --- | --- |
| **Imperative** | The *steps* to execute, in the right order | A script with Azure CLI commands (`az storage account create ...`) | Can fail or create duplicates. You have to handle "already exists" yourself. |
| **Declarative** | The *end state* you want | Bicep, ARM templates, Terraform | The tool compares what you want with what exists and only makes the changes that are needed. |

Real IaC is **declarative**. The most important property that follows from this is **idempotency**: deploying the same file once or ten times gives exactly the same result. If nothing changed in your code, nothing changes in Azure.

### 2.4. Key benefits

- **Consistency:** development, test and production are built from the same code, so they don't drift apart.
- **Repeatability:** rebuild a complete environment in minutes, for example after a disaster or for a new customer.
- **Version control:** every change is in Git. You know who changed what, when and why, and you can roll back.
- **Collaboration:** infrastructure changes go through pull requests and code reviews, just like application code.
- **Automation:** a CI/CD pipeline deploys your infrastructure, not someone's laptop.
- **Documentation:** the code always shows how your environment is really built.
- **Fewer manual errors:** no forgotten checkboxes or typos in the portal.

### 2.5. Challenges and good practices

| Challenge | Good practice |
| --- | --- |
| **Drift:** someone changes a resource by hand in the portal, so the code no longer matches reality | Make every change in code. Use *what-if* to detect differences. Limit write access in the portal for test and production. |
| **Secrets:** passwords, keys and connection strings must never end up in Git | Use secure parameters (`@secure()`), Azure Key Vault and pipeline secrets. |
| **Different environments:** development needs a cheaper setup than production | Use parameters, with one parameter file per environment. |
| **Large, unreadable files** | Split your code into small, reusable modules. |
| **Unexpected changes** | Preview every deployment, review it in a pull request and deploy to development first. |
| **Learning curve:** a new language and new tools | Start small, use the VS Code extension and the documentation. |

## 3. Infrastructure as Code on Azure

### 3.1. Azure Resource Manager

Everything you do in Azure, whether you click in the portal, run an Azure CLI command or deploy a Bicep file, goes through the same service: **Azure Resource Manager (ARM)**. ARM is the deployment and management layer of Azure.

```text
Azure portal  ──┐
Azure CLI     ──┤
PowerShell    ──┼──►  Azure Resource Manager  ──►  Resource providers   ──►  Your resources
Bicep / ARM   ──┤     sign-in, RBAC, policy,       Microsoft.Storage,        storage account,
Terraform     ──┘     deployment history           Microsoft.ServiceBus      Service Bus, ...
```

Azure Resource Manager:

- Checks who you are and what you are allowed to do (role-based access control, RBAC). That is why you can only deploy to your own resource group.
- Checks the rules of Azure Policy, for example which regions are allowed.
- Sends your request to the right **resource provider**, for example `Microsoft.Storage` for storage accounts.
- Keeps a **deployment history** for every resource group.

Every Azure resource has a **resource type** and an **API version**, for example `Microsoft.Storage/storageAccounts@2025-06-01`. The resource type tells ARM which provider handles the resource. The API version fixes which properties you can use. You see both in every IaC language for Azure.

### 3.2. IaC languages for Azure

- **ARM templates** are the native format of Azure Resource Manager, written in JSON. They are complete but verbose and hard to write by hand.
- **Bicep** is Microsoft's own language for Azure IaC. A Bicep file is compiled to an ARM template before it is deployed, so everything ARM can do, Bicep can do, with much shorter and more readable code.
- **Terraform** (by HashiCorp) uses its own language, HCL, and works with many clouds and services: Azure, AWS, Google Cloud, GitHub, ... It keeps track of what it deployed in a **state file**, which you must store and protect yourself.
- **Pulumi** lets you write IaC in a general programming language such as C#, TypeScript or Python.

| | ARM templates | Bicep | Terraform |
| --- | --- | --- | --- |
| **Language** | JSON | Bicep | HCL |
| **Made by** | Microsoft | Microsoft | HashiCorp |
| **Clouds** | Azure only | Azure only | Multi-cloud |
| **State** | Azure itself is the state | Azure itself is the state | Separate state file to store and protect |
| **New Azure features** | Available immediately | Available immediately | After a provider update (or via the AzAPI provider) |
| **Readability** | Low | High | High |

> **REMARK:** In these courses we use **Bicep**. It is the native Azure language, needs no state file, and has excellent support in VS Code. Terraform is a good choice when a company works with several clouds. The concepts you learn here (declarative code, parameters, modules, what-if/plan) apply to both.

### 3.3. Bicep in a nutshell

A small Bicep file that deploys a Log Analytics workspace:

```bicep
@description('Name of the Log Analytics workspace')
param workspaceName string

@description('Azure region, defaults to the region of the resource group')
param location string = resourceGroup().location

var retentionInDays = 30

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: retentionInDays
  }
}

output workspaceId string = workspace.id
```

**Building blocks:**

| Element | Keyword | Purpose |
| --- | --- | --- |
| **Parameter** | `param` | Input value that you pass in at deployment time, optionally with a default value |
| **Variable** | `var` | Value that you calculate or reuse inside the file |
| **Resource** | `resource` | An Azure resource to deploy: a symbolic name, the type with API version, and its properties |
| **Output** | `output` | Value returned after the deployment, e.g. a resource ID or an endpoint |
| **Decorator** | `@description()`, `@minLength()`, `@allowed()`, `@secure()` | Documentation and validation of parameters |
| **Function** | `resourceGroup()`, `uniqueString()`, ... | Built-in functions, e.g. to get the region of the resource group or to generate a unique name |
| **Module** | `module` | Reuse another Bicep file: your own, or a ready-made one from the public registry (Azure Verified Modules) |
| **Existing resource** | `existing` | Refer to a resource that already exists, without deploying it |

**Good to know:**

- `workspace` is the **symbolic name**. You only use it inside your Bicep file, e.g. `workspace.id`. The real name in Azure is the `name` property.
- Some resources live *inside* another resource, e.g. a blob container inside a storage account. These are **child resources**; you link them to their parent with the `parent` property.
- Values per environment go in a **parameter file** (`.bicepparam`), e.g. one for development and one for production:

  ```bicep
  using './main.bicep'

  param workspaceName = 'log-myapp-dev'
  ```

- `az bicep build --file main.bicep` compiles your Bicep file to an ARM template (`main.json`). You normally don't need to do this yourself: the Azure CLI compiles automatically when you deploy a `.bicep` file.

More information: <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview>

### 3.4. Deployments

#### Deployment scopes

A deployment always targets a scope. The default scope of a Bicep file is a resource group; you change it with `targetScope`.

| Scope | Azure CLI command | Typical resources |
| --- | --- | --- |
| **Resource group** | `az deployment group create` | Almost all resources: storage, Service Bus, Function Apps, ... |
| **Subscription** | `az deployment sub create` | Resource groups, policies, budgets |
| **Management group** | `az deployment mg create` | Policies and role assignments for many subscriptions |
| **Tenant** | `az deployment tenant create` | Management groups, tenant-wide settings |

> **REMARK:** In these courses you only have rights on your own resource group `rg-{FirstName}-{Name}`, so you always deploy at **resource group** scope.

#### Deployment modes

- **Incremental** (default): resources in your file are created or updated. Resources in the resource group that are *not* in your file are left alone.
- **Complete**: resources in the resource group that are *not* in your file are **deleted**. Microsoft is phasing out this mode; use *deployment stacks* if you want deployments to remove resources.

> **REMARK:** Incremental works per *resource*, not per *property*. When you redeploy a resource, every property you leave out of your file is set back to its default value. Your Bicep file must always describe the complete end state of a resource.

#### What-if

With **what-if** you preview a deployment without changing anything (`az deployment group what-if`). For every resource it shows the change type:

| Change type | Meaning |
| --- | --- |
| **Create** | The resource doesn't exist yet and will be created |
| **Modify** | The resource exists and some properties will change |
| **NoChange** | The resource exists and stays the same |
| **Delete** | The resource will be deleted (complete mode only) |
| **Ignore** | The resource exists but isn't in your file, so it isn't touched |

What-if is not perfect: sometimes it reports a change for a property that Azure fills in itself. This is called *noise*.

#### Deployment history

Every deployment is stored in the resource group, with its name, parameters, outputs and status: **Resource group > Settings > Deployments**. This is the first place to look when a deployment fails.

## 4. What you need

### 4.1. Azure

- **Azure subscription and resource group:** the school provides the subscription `Power Tools/Integration` and your personal resource group `rg-{FirstName}-{Name}`. See *Deploy Azure Resources*, 3.1. Tooling for Azure, for the directory details and how to switch directory.
- **Permissions:** you have **Contributor** on your own resource group. That is enough to deploy Bicep files there, and nowhere else.

### 4.2. Local tooling

| Tool | Why you need it | Check |
| --- | --- | --- |
| **VS Code** | Editor | |
| **Bicep extension for VS Code** | IntelliSense, validation, linter, visualizer, and deploying straight from VS Code | Extensions view |
| **Azure CLI** | Sign in to Azure, preview and deploy | `az --version` |
| **Bicep CLI** | Compiles Bicep. Installed and updated through the Azure CLI | `az bicep version` |
| **Git** | Version control of your code | `git --version` |

For installation, see *Deploy Azure Resources*, 3.2.2. Installation Tooling VS Code.

> **REMARK:** Problems installing the tools? The **Azure Cloud Shell** (the `>_` icon at the top of the Azure portal) has the Azure CLI and Bicep preinstalled.

### 4.3. Automation

In a real project nobody deploys from their own laptop; a pipeline does. For that you need three more things:

- A **Git repository**, e.g. on GitHub.
- An **identity for the pipeline**: an app registration (service principal) with rights on the resource group.
- A **pipeline**, e.g. GitHub Actions or Azure DevOps Pipelines.

You build all three in *Deploy Azure Resources*, chapter 5.

## 5. Exercise: Deploy a storage account with Bicep

> **REMARK:** In this exercise you deploy from your own laptop with the Azure CLI, signed in with your school account. In *Deploy Azure Resources* you automate the same kind of deployment with GitHub Actions.

### 5.1. Prepare your environment

**Assignment:**

- Check that the Azure CLI and the Bicep CLI are installed and up to date.
- Install the Bicep extension in VS Code.
- Sign in with the Azure CLI to the course directory and select the subscription `Power Tools/Integration`.
  - Info: *Deploy Azure Resources*, 3.1
- Check from the CLI that you can see your resource group `rg-{FirstName}-{Name}`.
- Create a new folder, e.g. `iac-exercise`, and open it in VS Code.

### 5.2. Write your Bicep file

**Assignment:**

- Create a new Bicep file
  - Name: `main.bicep`
- Add Bicep code for a storage account
  - Info: <https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts?pivots=deployment-language-bicep>
  - Do not blindly copy paste
  - Name: `stiac` followed by a unique string based on your resource group (look up the Bicep function `uniqueString`)
  - Region: the region of your resource group, as a parameter with a default value
  - Kind: StorageV2
  - Performance: Standard
  - Redundancy: Locally-redundant storage (LRS)
  - Minimum TLS version: 1.2
  - Anonymous blob access: disabled
  - Tag: `course` with value `iac`
- Add an output with the name of your storage account
- Check your file for errors before you deploy

> **REMARK:** Why `uniqueString`? A storage account name must be 3–24 characters long, may only contain lowercase letters and numbers, and must be unique across all of Azure. `uniqueString(resourceGroup().id)` returns 13 characters that are always the same for *your* resource group, but different for every other student. Every deployment uses the same name, which is exactly what you need for idempotent deployments.

### 5.3. Preview and deploy

**Assignment:**

- Preview the deployment to your resource group with what-if
  - Info: <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-what-if>
  - Which change type do you see for your storage account?
- Deploy your Bicep file to your resource group `rg-{FirstName}-{Name}`
  - Info: <https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-cli>
  - Give your deployment a name, e.g. `iac-storage`
- Verify in the Azure portal:
  - Your storage account is in your resource group, with the settings and tag from 5.2.
  - **Settings > Deployments** of your resource group shows your deployment and its output.

### 5.4. Change and redeploy

**Assignment:**

- Extend your Bicep file with a blob container in your storage account
  - Name: `iac`
  - Info: <https://learn.microsoft.com/en-us/azure/templates/microsoft.storage/storageaccounts/blobservices/containers?pivots=deployment-language-bicep>
  - A container is a child resource (see 3.3)
- Run what-if again. Which resources will be created, and which stay the same?
- Deploy again and check the container in the portal.
- Deploy a third time without changing anything. What happens, and why is that important? (see 2.3)

### 5.5. Extra: detect drift (optional)

**Assignment:**

- In the Azure portal, change the value of the tag `course` on your storage account.
- Run what-if again. What does your Bicep file want to do?
- Deploy again and check the tag. What does this tell you about where the "truth" of your environment lives?

## 6. Solution

This chapter contains a working solution for chapter 5. Try it yourself first and only use this to check your work or when you are stuck.

In all code below, replace `{FirstName}` and `{Name}` with your own name, in the same way as your resource group (ASCII only, e.g. `rg-Efrain-Mouton`).

### 6.1. main.bicep

File: `main.bicep` (including the container from 5.4)

```bicep
@description('Name of the storage account: stiac followed by a unique string for your resource group')
@minLength(3)
@maxLength(24)
param storageAccountName string = 'stiac${uniqueString(resourceGroup().id)}'

@description('Azure region, defaults to the region of the resource group')
param location string = resourceGroup().location

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-06-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  tags: {
    course: 'iac'
  }
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
  }
}

// 5.4: the blob service and the container are child resources of the storage account
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2025-06-01' = {
  parent: storageAccount
  name: 'default'
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-06-01' = {
  parent: blobService
  name: 'iac'
}

output storageAccountName string = storageAccount.name
output blobEndpoint string = storageAccount.properties.primaryEndpoints.blob
```

What it does:

- `param storageAccountName`: defaults to `stiac` + 13 characters from `uniqueString`, 18 characters in total. `@minLength` and `@maxLength` enforce the naming rules before Azure is even called.
- `param location`: defaults to the region of your resource group (North Europe).
- `resource storageAccount`: a general-purpose v2 storage account, Standard performance, locally-redundant (LRS), TLS 1.2 and no anonymous blob access, with the tag `course: iac`.
- `resource blobService` and `resource container`: the container `iac`. Every storage account has exactly one blob service, which is always called `default`; the container lives inside it. `parent` links each child to its parent.
- `output`: after deployment the name and blob endpoint of your storage account appear in the deployment output.

### 6.2. Commands

```bash
# 5.1: sign in to the course directory and select the course subscription
az login --tenant abinet.onmicrosoft.com
az account set --subscription deee63f4-2585-48ae-9104-bb288fbdd29f
az group show --name rg-{FirstName}-{Name}

# 5.1: install or update Bicep
az bicep install
az bicep upgrade

# 5.2: compile the Bicep file (creates main.json, the ARM template it compiles to)
az bicep build --file main.bicep

# 5.3 and 5.4: preview and deploy to your own resource group
az deployment group what-if --resource-group rg-{FirstName}-{Name} --template-file main.bicep
az deployment group create --name iac-storage --resource-group rg-{FirstName}-{Name} --template-file main.bicep
```

> **REMARK:** Open the generated `main.json` once to see how much shorter Bicep is than the ARM template it compiles to. You don't need to keep this file.

### 6.3. Run and verify

1. **5.3:** what-if shows **Create** for the storage account. After the deployment, the storage account `stiac...` is in your resource group, with the tag `course: iac`. The deployment `iac-storage` under **Settings > Deployments** shows the name and blob endpoint as outputs.
2. **5.4:** what-if shows **Create** for the container and **NoChange** for the storage account (sometimes with some noise, see 3.4). After the deployment, the container `iac` is visible under **Data storage > Containers**.
3. **5.4, third deployment:** nothing changes in Azure. Because Bicep is declarative, you can safely deploy the same file as often as you want: that is idempotency.
4. **5.5:** what-if shows **Modify** for the tag `course`: it wants to set the value back to `iac`. After the deployment the tag is `iac` again. Your code is the source of truth; manual changes are overwritten by the next deployment.

> **REMARK:** If you reuse the same deployment name (`iac-storage`), the previous entry in the deployment history is overwritten. Use a new name, e.g. `iac-storage-2`, if you want to keep both.

Common errors:

| Error | Cause | Fix |
| --- | --- | --- |
| `Please run 'az login' to setup account` | You are not signed in, or your sign-in expired | `az login --tenant abinet.onmicrosoft.com` |
| `ResourceGroupNotFound` | Typo in the resource group name, or the wrong subscription or directory is selected | Check with `az account show` and `az group list --output table` |
| `AuthorizationFailed` | You deploy to a resource group that isn't yours, or at subscription scope | Use your own resource group and `az deployment group create` |
| `AccountNameInvalid` | The name has capitals or hyphens, or is longer than 24 characters | Follow the naming rules in 5.2 |
| `StorageAccountAlreadyTaken` | The name is already used somewhere in Azure | Use `uniqueString` as described in 5.2 |
| `BCP...` | Syntax or type error in your Bicep file | Hover over the red underline in VS Code and fix the error |
