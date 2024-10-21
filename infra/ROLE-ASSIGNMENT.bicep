param identityId string
param roleDefinitionId string
param principalId string

var roleAssignmentName= guid(identityId, roleDefinitionId, resourceGroup().id)
resource RA 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
    name: roleAssignmentName
    properties: {
        roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
        principalType: 'ServicePrincipal'
        principalId: principalId
    }
}
