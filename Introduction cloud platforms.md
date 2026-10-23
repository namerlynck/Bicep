IT INTEGRATION

GENERAL INFORMATION
Course information
Friday 15u15 – 17u15
Room: H-60.11
Exam: 70% practical – 30% theoretical
Course teachers
Sam Deschuymer (sam.deschuymer@gmail.com)
Jaro Greniers (jaro@backlog.be)
2

INTRODUCTION

INTEGRATIE? GOALS?
• Buiten de “silo” kijken
| • Connectiviteit          | met andere | softwarepakketten |     | & system |
| ------------------------- | ---------- | ----------------- | --- | -------- |
| • Enterprise architecture |            |                   |     |          |
• Bijkomend
| • Nadenken | over waar | en hoe | dit draait |     |
| ---------- | --------- | ------ | ---------- | --- |
• Cloud providers
• Kostenbeheer
| • Alles rond | softwareontwikkeling |     |     |     |
| ------------ | -------------------- | --- | --- | --- |
4

PRAKTISCH
“MOETEN WE DIT KENNEN VOOR HET EXAMEN?”
| • Niet   | alles staat       | in de slides |                |            |
| -------- | ----------------- | ------------ | -------------- | ---------- |
| •        | Vaak worden       | dingen       | verteld        |            |
| •        | Aanwezigheid      | niet         | verplicht, wel | aangeraden |
| • Sterke | focus op praktijk |              |                |            |
| •        | Vaak worden       | dingen       | verteld        |            |
5

6

CLOUD
COMPUTING

CLOUD COMPUTING
• Available through networks
Cloud computing is the on-demand availability of
• Basic services
computer system resources
• Compute power
• Storage
• Selected services per provider
8

CLOUD MODELS
| • Private – | Public –       | Hybrid |
| ----------- | -------------- | ------ |
| • Shared    | responsibility | model  |
•
Cloud provider <> Consumer
9

CLOUD MODELS
10

CONSUMPTION BASED MODEL
• Capital Expenditure < > Operational Expenditure
• Consumption based model
• No upfront costs
• No unnecessary infrastructure
• Scalability
11

BENEFITS OF THE CLOUD?
• High availability (service level agreements)
• Scalability
• Vertical < > Horizontal
• Security
• …
12

CLOUD PROVIDERS
13

CLOUD PROVIDERS
14
Source: https://holori.com/cloud-market-share-2026-top-cloud-vendors-in-2026/

EXAMPLE CLOUD
PROVIDER:
MICROSOFT
AZURE

MICROSOFT AZURE
https://www.microsoft.com/en-
us/videoplayer/embed/RWEsag?postJsllMsg=true
16

AZURE PORTAL
• https://portal.azure.com/
• Build, manage, and monitor everything from simple web apps to
complex cloud deployments.
• Create custom dashboards for an organized view of resources.
• Configure accessibility options for an optimal experience.
17

18

19

EXAMPLE CLOUD
PROVIDER:
AZURE
RESOURCES

AZURE RESOURCES
Commonly used resources
• Logic Apps
• Azure Functions
• Web Apps
• Virtual machines/ networks
• SQL database
• Automation account
• Integration account
• Service bus – Event grid
• API Management
• Keyvault
• Container apps

PERIODIC TABLE
22
Source: https://www.azureperiodictable.com/

CONTAINER APPS
• (Docker) containers, on Azure
• PaaS – flexible scaling (scale to 0)
• External registry, or via Azure Container Registry
• Built-in loadbalancer & TLS
23

LOGIC APPS
• Business process
• Visual programming in the cloud
• “Glue” between (Azure) resources
| • Custom connectors |             |            |
| ------------------- | ----------- | ---------- |
| • Integrated        | with nearly | everything |
• Amazon: AWS – step functions

LOGIC APPS

INTEGRATION ACCOUNT
• Addition to Logic Apps
• Complex Transformation with Maps
• Complex message definitions with Schema
• Support for XML processing like validation and
transformation
• Trading Partner Management
• B2B support for EDI, X12, EDIFACT, AS2

AZURE FUNCTION
• Serverless code
• Different languages & runtimes
• Google: Cloud functions

AZURE RESOURCES
Logic apps vs Azure Function

WEB APPS
• Serverless webhosting
• Websites
• API’s
• …
• Different languages & runtimes
• Examples: .NET Core (C#), Javascript (NodeJS), PHP, …
• Amazon: Elastic Beanstalk

SQL DATABASE
• Cloud databases
• Scalable
• Fixed or consumption-based pricing
• Alternative to running your own on a (Azure) VM

SQL DATABASE
SQL Database
• Scaling of the database
• DTU purchase model
• vCore purchase model
• Google: Cloud SQL

API MANAGEMENT
Azure API Management is a cloud service
that gives you a platform for publishing,
securing, maintaining, and analysing all
your company's APIs.
Mulesoft: Anypoint Platform

KEYVAULT
• Securely storing and accessing secrets
• API keys
• Passwords
• Credentials
• Cryptographic keys
• Amazon: Key Management Service

SERVICE BUS
Message broker
Google: Cloud Pub/Sub

EXAMPLE CLOUD
PROVIDER:
CREATING AZURE
RESOURCES

CREATING AZURE RESOURCES
How to create an azure resource
• Azure portal
• Azure CLI
• VS Code
• Deploy application Code

AZURE PORTAL
• Portal link: https://portal.azure.com
• Follow the wizard

AZURE CLI
• Local
• Install tools: https://learn.microsoft.com/en-us/cli/azure/install-
azure-cli

VS CODE
• Install Visual Studio Code
• Install appropriate extensions
• Azure Logic Apps
• Azure Functions
• Azure Account
• Azure CLI tools
• Azure Pipelines
• Azure App Service
• …

DEPLOY APPLICATION CODE
• Infrastructure as code
• ARM – Templates
• Bicep – Templates
• Version Control
• Easy to replicate set-up

DEPLOY APPLICATION CODE
Code in IDE Azure
• Through CI/CD (preferred)
• Through Azure CLI
• Via Azure REST API
Code in
(Package) Azure
• Through the Azure portal IDE
• Via Visual Studio of VS Code
Code in
Repository Artifacts Azure
IDE

VMS AND
CONTAINERS

VM’S AND CONTAINERS
Virtual machines
Containers
• Abstract of physical hardware
• Abstraction at the app layer
• Hypervisor
• Package of code and
dependencies
• Each VM
• Share the OS kernel
• Operating system
• Applications
43

QUESTIONS?
Source: https://xkcd.com/293/ 45

---

# UITWERKING & OPDRACHTEN (IT INTEGRATION)

In dit deel worden de opdrachten, open vraagstukken en praktijkstappen uit deze introductieles volledig uitgewerkt.

---

## Opdracht 1: Vergelijking Logic Apps vs Azure Functions (Slide 166)

| Eigenschap | Azure Logic Apps | Azure Functions |
| :--- | :--- | :--- |
| **Aanpak** | **No-code / Low-code**: Visuele designer (workflow engine) in de browser of VS Code. | **Code-first**: Serverless code schrijven in o.a. C#, JavaScript/TypeScript, Python, PowerShell. |
| **Primaire use-case** | Bedrijfsprocessen modelleren, orkestratie van API's en kant-en-klare connectors (SaaS, Office 365, Salesforce, SAP). | Complexe bedrijfslogica, data-transformaties, rekenintensieve achtergrondtaken of custom algoritmes. |
| **Connectiviteit** | Honderden out-of-the-box connectors (triggers en acties) zonder zelf authenticatie/code te schrijven. | Verbinding via code libraries of bindings (in/out triggers), vereist meer handmatig configuratiewerk. |
| **Prijsmodel** | Verbruiksmodel per actie-uitvoering (Consumption) of vaste prijs per vCPU/RAM (Standard App Service Plan). | Consumption plan (eerste 1 miljoen executies per maand gratis) of Premium / Dedicated plan. |
| **Monitoring** | Volledige visuele run history met invoer/uitvoer per stap in de portal. | Application Insights integratie met gedetailleerde logboeken en metrics. |

> **Conclusie:** Gebruik **Logic Apps** voor workflow-orkestratie en integratie tussen bestaande systemen. Gebruik **Azure Functions** wanneer je specifieke custom code, transformaties of algoritmes moet uitvoeren. In de praktijk worden ze vaak samen gebruikt (een Logic App die een Azure Function aanroept).

---

## Opdracht 2: Vergelijking Virtual Machines vs Containers (Slide 264)

| Eigenschap | Virtual Machines (VM's) | Containers (bijv. Container Apps / Docker) |
| :--- | :--- | :--- |
| **Abstractielaag** | Hardware-abstractie via een **Hypervisor** (Type 1 of Type 2). | Applicatielaag-abstractie; containers delen dezelfde **OS kernel**. |
| **Besturingssysteem** | Elke VM draait een volledig eigen besturingssysteem (Guest OS), inclusief drivers, kernel en updates. | Geen eigen OS; bevat enkel de applicatiecode, dependencies en runtime libraries. |
| **Grootte & Opstarttijd** | Zwaar (vele gigabytes) en trage opstarttijd (enkele minuten). | Zeer lichtgewicht (enkele megabytes tot honderden MB's) en start op in seconden of milliseconden. |
| **Schaalbaarheid** | Trager en complexer horizontaal op te schalen. | Ideaal voor microservices, schaalt snel (zelfs schalen naar 0 via Azure Container Apps / KEDA). |
| **Isolatie & Beveiliging** | Sterkste isolatie op hardware/kernel-niveau. | Isolatie via namespaces en cgroups op OS-niveau. |

---

## Opdracht 3: Cloud Deployment Modellen & Shared Responsibility (Slide 54-60)

### 1. Deployment Modellen
- **Public Cloud (bijv. Microsoft Azure, AWS, GCP):** Infrastructuur is eigendom van de cloudprovider en wordt gedeeld over meerdere klanten (multi-tenant). Hoge schaalbaarheid en geen hardware-onderhoud.
- **Private Cloud:** Volledig toegewijd aan één organisatie (on-premises datacenter of hosted). Maximale controle en compliance, maar hoge initiële kosten.
- **Hybrid Cloud:** Combinatie van on-premises / private cloud en public cloud, onderling verbonden via veilige netwerken (bijv. Azure ExpressRoute of VPN).

### 2. Shared Responsibility Model
De verantwoordelijkheid verschuift naargelang het gekozen servicemodel:
- **IaaS (Infrastructure as a Service - bijv. Azure VM):** Provider beheert fysieke datacenter, servers en hypervisor. De klant beheert OS, patching, netwerkconfiguratie en applicaties.
- **PaaS (Platform as a Service - bijv. Azure App Service, Azure Functions, SQL Database):** Provider beheert hardware, OS, updates en runtime. De klant focust zich enkel op de applicatie en data.
- **SaaS (Software as a Service - bijv. Microsoft 365):** Provider beheert de volledige stack. De klant beheert enkel data en gebruikersrechten.

---

## Opdracht 4: Kostenmodellen: CapEx vs OpEx (Slide 65-72)

- **CapEx (Capital Expenditure):**
  - Traditioneel on-premises model.
  - Grote initiële investering vooraf (aankoop van fysieke servers, switches, koeling, licenties).
  - Waarde vermindert over tijd (afschrijving over 3 tot 5 jaar).
  - Risico op overcapaciteit of juist tekort aan rekenkracht.
- **OpEx (Operational Expenditure):**
  - Cloud / Consumption-based model (*Pay-as-you-go*).
  - Geen grote kosten vooraf.
  - Betalen voor wat je daadwerkelijk verbruikt (per minuut, per GB opslag, per API-call).
  - Kosten zijn direct operationeel aftrekbaar en flexibel op- en afschaalbaar naar behoefte.

---

## Opdracht 5: Azure SQL Database modellen: DTU vs vCore (Slide 184-188)

- **DTU (Database Transaction Unit):**
  - Gebundelde maatstaf van compute, geheugen en I/O.
  - Eenvoudig en voorspelbaar voor eenvoudige, gestandaardiseerde workloads (Basic, Standard, Premium).
  - Minder flexibel om individuele componenten los van elkaar te schalen.
- **vCore (Virtual Core):**
  - Geeft onafhankelijke controle over compute (aantal vCores) en opslagcapaciteit (GB/TB).
  - Meer transparantie en geschikt voor veeleisende enterprise applicaties.
  - Ondersteunt Azure Hybrid Benefit (gebruik van bestaande SQL Server licenties voor korting).

---

## Opdracht 6: Praktische Uitvoering & Tooling (Slide 209-260)

De praktische component van deze les focust op het geautomatiseerd provisioneren van cloud-resources via **Infrastructure as Code (IaC)** en **CI/CD**.

### Uitgevoerde stappen:
1. **Lokale Ontwikkelomgeving (VS Code & CLI):**
   - Geïnstalleerde VS Code extensies:
     - `ms-vscode.azurecli` (Azure CLI Tools)
     - `ms-azuretools.vscode-bicep` (Bicep taalondersteuning)
     - `ms-azuretools.vscode-azurelogicapps` (Azure Logic Apps)
     - `ms-azuretools.vscode-azurefunctions` (Azure Functions)
     - `ms-azuretools.vscode-azureappservice` (Azure App Service)
     - `ms-azure-devops.azure-pipelines` (Azure Pipelines)
2. **Infrastructure as Code (Bicep):**
   - Service Bus definitie aangemaakt in `infra/main.bicep`:
     - Resource: `Microsoft.ServiceBus/namespaces@2024-01-01`
     - Naam: `sb-Nathan-Amerlynck`
     - Tier: `Basic`
     - TLS-versie: `1.2`
   - Lokaal gevalideerd en gecompileerd via `az bicep build`.
3. **CI/CD Pipeline (GitHub Actions):**
   - Workflow ingericht in `.github/workflows/deploy-servicebus.yml`.
   - Authenticatie via een Service Principal met GitHub Secrets:
     - `AZURE_CLIENT_ID`
     - `AZURE_CLIENT_SECRET`
     - `AZURE_SUBSCRIPTION_ID`
     - `AZURE_TENANT_ID`
   - Geautomatiseerde deployment naar resource group `rg-Nathan-Amerlynck`.
