param appName string = 'alert'
param location string = resourceGroup().location
param rg string = 'alertservice'
param vnetName string = '${appName}-vnet'
param storageName string = '${appName}store'

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    accessTier: 'Hot'
    routingPreference: {
      publishMicrosoftEndpoints: true
    }
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: '01'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: '02'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}
