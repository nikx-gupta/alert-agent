param appName string = 'alert'
param vnetName string = '${appName}-vnet'
param location string = resourceGroup().location
param rg string = 'alertservice'

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
