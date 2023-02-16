provider "prosimo" {
  token    = var.prosimo_token
  insecure = true
  base_url = "https://${var.prosimo_teamName}.admin.prosimo.io"
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

locals {
  purpose     = "prosimopoc"
  cloudConfig = jsondecode(file(var.configFile))
}

module "azure-region" {
  count         = length(var.deployment)
  adminUserName = var.deployment[count.index].adminName
  adminPassword = var.adminPassword
  azureEdges    = local.cloudConfig.edgeCIDR["Azure"]
  publicIp      = false
  purpose       = local.purpose
  vmSize        = var.deployment[count.index].vmSize
  region        = var.deployment[count.index].region
  source        = "/Modules/azure-winvm-with-vnet"
  vmName        = var.deployment[count.index].vmName
  vnetAddresses = var.deployment[count.index].cidr
}

module "prosimo-rdp" {
  count         = length(var.deployment)
  appConnection = "peering"
  appIp         = module.azure-region[count.index].vmIp
  appName       = "RDP-${var.deployment[count.index].region}-${var.deployment[count.index].vmName}"
  cloud         = "Azure"
  performance   = var.performance
  configFile    = var.configFile
  decommission  = var.decommission
  idp           = "okta"
  ports         = ["3389"]
  region        = var.deployment[count.index].region
  wait          = var.wait
  source        = "/Modules/u2a-agent-ip"
}

module "networks" {
  count        = length(var.deployment)
  name         = var.deployment[count.index].cidr
  region       = var.deployment[count.index].region
  networkId    = module.azure-region[count.index].networkId
  subnets      = module.azure-region[count.index].subnetCidrs
  connectType  = var.connectType
  cloud        = "Azure"
  wait         = var.wait
  decommission = var.decommission
  configFile   = var.configFile
  source       = "/Modules/prosimo-network"
}