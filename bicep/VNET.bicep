
param name string

@description('CIDR block representing the address space of the VNet')
param virtualNetworkPrefix string = '10.0.0.0/16'

@description('CIDR block representing the address space of the VNet')
param defaultSubPrefix string = '10.0.0.0/24'

@description('CIDR block for the gateway subnet, subset of VNet address space')
param gatewaySubPrefix string = '10.0.1.0/27'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01'= {
  name: '${name}-vn'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkPrefix
      ]
    }
    subnets: [
      {
        name: 'default'
        properties:{
          addressPrefix: defaultSubPrefix
        }
      }
      {
        name: 'GatewaySubnet'
        properties:{
          addressPrefix: gatewaySubPrefix
        }
      }
    ]
  }
}
