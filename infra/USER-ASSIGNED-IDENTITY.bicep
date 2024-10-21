@description('Prefix name for the VPN Resources')
param name string

var networkContributorRoleId = '4d97b98b-1d4f-4787-a291-c67834d212e7'
var containerInstancesContributorRoleId = '5d977122-f97e-4b4d-a52f-6b43003ddb4d'

resource dnsUai 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview'  = {
  name: '${name}-dns-uai'
  location: resourceGroup().location
}

module networkRA 'ROLE-ASSIGNMENT.bicep' = {
  name: 'dp-role-assignment-network'
  params: {
    identityId: dnsUai.id
    roleDefinitionId: networkContributorRoleId
    principalId: dnsUai.properties.principalId
  }
}

module containerInstancesRA 'ROLE-ASSIGNMENT.bicep' = {
  name: 'dp-role-assignment-container-instances'
  params: {
    identityId: dnsUai.id
    roleDefinitionId: containerInstancesContributorRoleId
    principalId: dnsUai.properties.principalId
  }
}
