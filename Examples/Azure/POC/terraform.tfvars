wait        = false
connectType = "vnet-peering"
performance = "CostSaving"
deployment = [
  {
    vmName    = "prosimopoc"
    adminName = "winadmin"
    vmSize    = "Standard_B2ms"
    region    = "eastus2"
    cidr      = "10.5.0.0/24"
  },
  {
    vmName    = "prosimopoc"
    adminName = "winadmin"
    vmSize    = "Standard_B2ms"
    region    = "westus3"
    cidr      = "10.6.0.0/24"
  }
]