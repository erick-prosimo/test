# DevOps/POC Starter

![Logo](/Assets/Images/prosimo-logo-darkmode.png#gh-dark-mode-only)
![Logo](/Assets/Images/prosimo-logo-lightmode.png#gh-light-mode-only)

---

  
## Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Diagrams](#diagrams)

---

POC Deployment Files

| AWS | Azure | GCP | Prosimo |  
| --- | --- | --- | --- |
| [terraform.tfvars](Examples/AWS/POC/terraform.tfvars) | [terraform.tfvars](Examples/Azure/POC/terraform.tfvars) | [terraform.tfvars](Examples/GCP/POC/terraform.tfvars) | [prosimo-config.json](prosimo-config.json) |





---

## Introduction

This repository contains pre-built GitHub Actions that will build sample infrastructure to test a Prosimo deployment in your environment. The actions are re-usable and may continue to be used beyond the intial testing phases if desired. It is typically recommended to test real applications and networks as part of a POC, and while advised it is not a requirement. 


---

## Prerequisites


1. A Prosimo team and access to the Prosimo portal
2. Cloud accounts with proper IAM roles in AWS, Azure, and GCP pre-configured in the Prosimo portal
3. A primary IDP provider configured in the Prosimo portal [^1]
4. Cloud credentials with enough access to provision compute and network resources in all 3 cloud providers [^2]
    

---

<details>
<summary>Initial Config</summary>

   
1. Create Personal Access Token (PAT)
2. Create GitHub Secrets
3. Update Secret Values
4. Edit Config File
5. Run Terraform Automation Workflow

[Detailed Instructions](Assets/Docs/readme.md#quick-start)
     
</details>

---   

<details>
<summary>Deployment Workflow</summary>

1. Create Branch
2. Commit Change to Branch
3. Issue Pull Request

[Detailed Instructions](Assets/Docs/readme.md)
  

</details>


--- 
## Diagrams

### Two Cloud 4-Region Edge Deployment

<img src="Assets/Images/prosimo-nodes-4-darkmode.png#gh-dark-mode-only">
<img src="Assets/Images/prosimo-nodes-4-lightmode.png#gh-light-mode-only">

---

### Three Cloud 6-Region Edge Deployment

<img src="Assets/Images/prosimo-nodes-6-darkmode.png#gh-dark-mode-only">
<img src="Assets/Images/prosimo-nodes-6-lightmode.png#gh-light-mode-only">

---

### Multi-Cloud User Access Patterns

<img src="Assets/Images/user-access-darkmode.png#gh-dark-mode-only">
<img src="Assets/Images/user-access-lightmode.png#gh-light-mode-only">




---


[^1]: The base deployment will create virtual machines in each cloud region in order to test connectivity. These virtual machines use private IP addressing, and as such Prosimo provides agent-based SSH and RDP access as part of the initial deployment in order to securely access these systems remotely. The Prosimo Agent is avaiable on Mac OS and Windows and can co-exist with existing VPN clients. The agent can be downloaded from your Prosimo portal using the following URL replacing `teamName` with your Prosimo team name: https://`teamName`.admin.prosimo.io/dashboard/agent/download

[^2]: The credentials used in the setup of your Prosimo team will have enough permissions to create the items in this repository. If you wish to use these pipelines to deploy additional resources (databases, PaaS services, etc.) make certain to update the repo secrets with service principal/IAM roles that have appropriate privileges.