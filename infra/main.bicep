@description('Prefix name for the VPN Resources')
param name string

// VNET
module vnet 'VNET.bicep' = {
  name: 'dp-vnet'
  params: {
    name: name
  }
}

// VPN Gateway
module vnet_gateway 'VNET-GATEWAY.bicep' = {
  name: 'dp-vnet-gateway'
  params: {
    name: name
  }
  dependsOn: [
    vnet
  ]
}

// User Assigned Identity
module uai 'USER-ASSIGNED-IDENTITY.bicep' = {
  name: 'dp-user-assigned-identity'
  params: {
    name: name
  }
}

// DNS Forwarder and IP Sync Containers
module containers 'CONTAINERS.bicep' = {
  name: 'dp-containers'
  params: {
    name: name
    dnsImage: 'ghcr.io/bcage29/az-dns-forwarder:latest'
    ipAddressSyncImage: 'ghcr.io/bcage29/az-dns-forwarder/ip-sync:latest'
  }
  dependsOn: [
    uai
    vnet
  ]
}
