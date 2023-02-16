configFile    = "../../../prosimo-config.json"
wait          = false
cacheRuleName = "Default Cache"
deployment = [
  {
    vmName = "prosimopoc"
    vmSize = "t3a.small"
    region = "us-east-2"
    cidr   = "10.50.3.0/24"
  },
  {
    vmName = "prosimopoc"
    vmSize = "t3a.small"
    region = "eu-west-1"
    cidr   = "10.51.3.0/24"
  }
]