## Automated Deployment

This section contains pre-built automation that is triggered by either manually running the selected GitHub action, or by editing the terraform.tfvars file in a specified path. Infrastructure may also be removed after a run by adding or changing any character in the terraform.tfvars file and using the name: `terraform destroy` as the commit message.

<img src="../Assets/Images/commit-tf-destroy.png">

---

This repo has pre-configured pipelines that require no modification if running in a sandox environment. If you want to change details about the deployment you can edit the terraform.tfvars file in a specified path, or maniupulate the provided terraform files in any way you see fit.

| GitHub Action | Template | Deploys | 
| ------------- | ------------- | ------------- |
| [![Prosimo-Policy](https://github.com/prosimo-io/prosimo-poc/actions/workflows/prosimo-url-mfa-policy.yml/badge.svg)](https://github.com/prosimo-io/prosimo-poc/actions/workflows/prosimo-url-mfa-policy.yml) | [URL MFA Policy](Policy-URL-MFA/) | Prosimo policy requiring MFA when accessing a URL path containing `/admin` |
| [![Prosimo-Azure-U2A](https://github.com/prosimo-io/prosimo-poc/actions/workflows/prosimo-u2a-azurevm.yml/badge.svg)](https://github.com/prosimo-io/prosimo-poc/actions/workflows/prosimo-u2a-azurevm.yml) | User-to-App Agent Based with Azure VM  | VNet in Azure, Standard B2ms VM running Windows Server 2019, NSG allowing only intra-VNet communication and communication from the Prosimo Edge, and onboards the VM into Prosimo on TCP 3389 for agent-based remote access. |
