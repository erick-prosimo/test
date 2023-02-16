provider "prosimo" {
  token    = var.prosimo_token
  insecure = true
  base_url = "https://${var.prosimo_teamName}.admin.prosimo.io"
}

provider "aws" {
  region = var.deployment[0].region
  alias  = "region0"
}

provider "aws" {
  region = var.deployment[1].region
  alias  = "region1"
}

locals {
  purpose     = "prosimopoc"
  cloudConfig = jsondecode(file(var.configFile))
}

module "aws-region0" {
  providers = { aws = aws.region0 }
  awsEdges  = local.cloudConfig.edgeCIDR["AWS"]
  vmName    = var.deployment[0].vmName
  vmSize    = var.deployment[0].vmSize
  region    = var.deployment[0].region
  cidr      = var.deployment[0].cidr
  purpose   = local.purpose
  source    = "/Modules/aws-vpc-wordpress-ec2"
}

module "aws-region1" {
  providers = { aws = aws.region1 }
  awsEdges  = local.cloudConfig.edgeCIDR["AWS"]
  vmName    = var.deployment[1].vmName
  vmSize    = var.deployment[1].vmSize
  region    = var.deployment[1].region
  cidr      = var.deployment[1].cidr
  purpose   = local.purpose
  source    = "/Modules/aws-vpc-wordpress-ec2"
}

module "wordpress0" {
  appConnection    = "peering"
  appIp            = module.aws-region0.vmNicIp
  appName          = "Wordpress-${var.deployment[0].region}-${var.deployment[0].vmName}"
  cloud            = "AWS"
  configFile       = var.configFile
  decommission     = var.decommission
  domainType       = "prosimo"
  hostedDnsPrefix  = "${var.deployment[0].region}wordpress"
  idp              = local.cloudConfig.idp.name
  cacheRuleName    = var.cacheRuleName
  multicloud       = var.multicloud
  performance      = var.performance
  port             = "443"
  prosimo_teamName = var.prosimo_teamName
  region           = var.deployment[0].region
  wait             = var.wait
  source           = "/Modules/u2a-agentless-https"
}

module "wordpress1" {
  appConnection    = "peering"
  appIp            = module.aws-region1.vmNicIp
  appName          = "Wordpress-${var.deployment[1].region}-${var.deployment[1].vmName}"
  cloud            = "AWS"
  configFile       = var.configFile
  decommission     = var.decommission
  domainType       = "prosimo"
  hostedDnsPrefix  = "${var.deployment[1].region}wordpress"
  idp              = local.cloudConfig.idp.name
  cacheRuleName    = var.cacheRuleName
  multicloud       = var.multicloud
  performance      = var.performance
  port             = "443"
  prosimo_teamName = var.prosimo_teamName
  region           = var.deployment[1].region
  wait             = var.wait
  source           = "/Modules/u2a-agentless-https"
}

module "networks0" {
  name         = var.deployment[0].cidr
  region       = var.deployment[0].region
  networkId    = module.aws-region0.networkId
  subnets      = [module.aws-region0.subnetCidrs]
  connectType  = var.connectType
  cloud        = "AWS"
  wait         = var.wait
  decommission = var.decommission
  configFile   = var.configFile
  source       = "/Modules/prosimo-network"
}

module "networks1" {
  name         = var.deployment[1].cidr
  region       = var.deployment[1].region
  networkId    = module.aws-region1.networkId
  subnets      = [module.aws-region1.subnetCidrs]
  connectType  = var.connectType
  cloud        = "AWS"
  wait         = var.wait
  decommission = var.decommission
  configFile   = var.configFile
  source       = "/Modules/prosimo-network"
}

output "key0" {
  value     = module.aws-region0.privateKey
  sensitive = true
}

output "key1" {
  value     = module.aws-region1.privateKey
  sensitive = true
}
