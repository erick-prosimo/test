param name string
param location string
@allowed([
  'Standard_GRS'
  'Standard_LRS'
  'Standard_RAGRS'
])
param sku string
param tags object = {}

var stgName = '${toLower(name)}${toLower(take(uniqueString(name, location, subscription().id), 7))}'

resource stg 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: stgName
  location: location
  sku: {
    name: sku
  }
  kind: 'StorageV2'
  tags: tags
}

resource stgcontainer 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  name: 'default'
  parent: stg
}

resource tfstatecontainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  name: 'tfstate'
  parent: stgcontainer
}

output resourceId string = stg.id
output name string = stg.name
output containerName string = tfstatecontainer.name
