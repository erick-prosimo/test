targetScope = 'subscription'

param name string = 'tfstate'
param location string = deployment().location
param time string = utcNow()

var rgPrefix = 'rg-prosimo-${toLower(name)}'
var rgSuffix = toLower(take(uniqueString(name, location, subscription().id), 7))
var rgName = '${rgPrefix}-${rgSuffix}'
var tags = {
  CreatedBy: 'Prosimo'
  Purpose: 'Terraform State for Prosimo'
}

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
  tags: tags
}

module tfStorage 'storage.bicep' = {
  scope: rg
  name: 'tfstate-${time}'
  params: {
    location: rg.location
    name: name
    sku: 'Standard_RAGRS'
    tags: tags
  }
}

output storageName string = tfStorage.outputs.name
output rgName string = rg.name
output containerName string = tfStorage.outputs.containerName
