@description('Prefix name for the VPN Resources')
param name string = ''

@description('Name for the dns container group')
param dnsContainerGroupName string = 'dns-container-group'

@description('Name for the dns container')
param dnsContainerName string = 'dns'

@description('Name for the IP Address Sync container')
param ipAddressSyncContainerName string = 'ip-address-sync'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Container image to deploy. Should be of the form repoName/imagename:tag for images stored in public Docker Hub, or a fully qualified URI for other registries. Images from private registries require additional registry credentials.')
param dnsImage string

@description('Container image to deploy. Should be of the form repoName/imagename:tag for images stored in public Docker Hub, or a fully qualified URI for other registries. Images from private registries require additional registry credentials.')
param ipAddressSyncImage string

@description('Port to open on the container.')
param dnsPort int = 53

@description('The number of CPU cores to allocate to the container.')
param cpuCores int = 1

@description('The amount of memory to allocate to the container in gigabytes.')
param memoryInGb int = 1

@description('The behavior of Azure runtime if container has stopped.')
@allowed([
  'Always'
  'Never'
  'OnFailure'
])
param restartPolicy string = 'Always'

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: '${name}-vnet'
}

resource dnsSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-01-01' existing = {
  name: 'DnsSubnet'
  parent: vnet
}

resource dnsUai 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' existing  = {
  name: '${name}-dns-uai'
}

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2024-05-01-preview' = {
  name: dnsContainerGroupName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: { 
      '${dnsUai.id}': {}
    }
  }
  properties: {
    containers: [
      {
        name: dnsContainerName
        properties: {
          image: dnsImage
          ports: [
            {
              port: dnsPort
              protocol: 'UDP'
            }
          ]
          resources: {
            requests: {
              cpu: cpuCores
              memoryInGB: memoryInGb
            }
          }
        }
      }
      {
        name: ipAddressSyncContainerName
        properties: {
          image: ipAddressSyncImage
          ports: []
          resources: {
            requests: {
              cpu: cpuCores
              memoryInGB: memoryInGb
            }
          }
          environmentVariables: [
            {
              name: 'RESOURCE_GROUP_NAME'
              value: resourceGroup().name
            }
            {
              name: 'CONTAINER_GROUP_NAME'
              value: dnsContainerGroupName
            }
            {
              name: 'VNET_NAME'
              value: '${name}-vnet'
            }
          ]
        }
      }
    ]
    osType: 'Linux'
    restartPolicy: restartPolicy
    ipAddress: {
      type: 'Private'
      ports: [
        {
          port: dnsPort
          protocol: 'UDP'
        }
      ]
    }
    subnetIds: [
      {
        id: dnsSubnet.id
        name: dnsSubnet.name
      }
    ]
  }
}
