
param name string
var resourceGroupName = '${name}-rg'

targetScope = 'subscription'

module resourceGroupDeployment 'bicep/RG.bicep' = {
  name: 'dp-resource-group'
  scope: subscription()
  params: {
    name: name
  }
}

module vnet 'bicep/VNET.bicep' = {
  name: 'dp-vnet'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: name
  }
  dependsOn: [
    resourceGroupDeployment
  ]
}

module vnet_gateway 'bicep/VNET-GATEWAY.bicep' = {
  name: 'dp-vnet-gateway'
  scope: resourceGroup(resourceGroupName)
  params: {
    name: name
  }
  dependsOn: [
    resourceGroupDeployment
    vnet
  ]
}
