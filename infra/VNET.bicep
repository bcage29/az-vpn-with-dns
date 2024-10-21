@description('Prefix name for the VPN Resources')
param name string

@description('CIDR block representing the address space of the VNet')
param virtualNetworkPrefix string = '10.0.0.0/16'

@description('CIDR block for the default subnet, subset of VNet address space')
param defaultSubnetPrefix string = '10.0.0.0/24'

@description('CIDR block for the gateway subnet, subset of VNet address space')
param gatewaySubnetPrefix string = '10.0.1.0/27'

@description('CIDR block for the dns subnet, subset of VNet address space')
param dnsSubnetPrefix string = '10.0.1.48/29'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01'= {
  name: '${name}-vnet'
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
          addressPrefix: defaultSubnetPrefix
        }
      }
      {
        name: 'GatewaySubnet'
        properties:{
          addressPrefix: gatewaySubnetPrefix
        }
      }
      {
        name: 'DnsSubnet'
        properties:{
          addressPrefix: dnsSubnetPrefix
          delegations: [
            {
              name: 'aciDelegation'
              properties: {
                serviceName: 'Microsoft.ContainerInstance/containerGroups'
              }
            }
          ]
        }
      }
    ]
  }
}
