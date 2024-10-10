@description('Prefix name for the VPN Resources')
param name string

module vnet 'bicep/VNET.bicep' = {
  name: 'dp-vnet'
  params: {
    name: name
  }
}

module vnet_gateway 'bicep/VNET-GATEWAY.bicep' = {
  name: 'dp-vnet-gateway'
  params: {
    name: name
  }
  dependsOn: [
    vnet
  ]
}
