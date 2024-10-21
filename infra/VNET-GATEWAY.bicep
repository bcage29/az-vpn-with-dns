@description('Prefix name for the VPN Resources')
param name string

@description('The IP address range from which VPN clients will receive an IP address when connected. Range specified must not overlap with on-premise network')
param vpnClientAddressPool string = '172.28.1.0/24'

@description('The SKU of the Gateway. VpnGw1, VpnGw2, VpnGw3')
@allowed([
  'VpnGw1'
  'VpnGw2'
  'VpnGw3'
])
param gatewaySku string = 'VpnGw1'

var vnet = '${name}-vnet'
var tenantId = subscription().tenantId
var audience = 'c632b3df-fb67-4d84-bdcf-b95ad541b5c8'
var tenant = uri(environment().authentication.loginEndpoint, tenantId)
var issuer = 'https://sts.windows.net/${tenantId}/'
var gatewaySubnetRef = resourceId('Microsoft.Network/virtualNetworks/subnets', vnet, 'GatewaySubnet')

resource publicIP 'Microsoft.Network/publicIPAddresses@2024-01-01' = {
  name: '${name}-gateway-pip'
  location: resourceGroup().location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource vpnGateway 'Microsoft.Network/virtualNetworkGateways@2024-01-01' = {
  name: '${name}-gateway'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: gatewaySubnetRef
          }
          publicIPAddress: {
            id: publicIP.id
          }
        }
        name: 'vnetGatewayConfig'
      }
    ]
    sku: {
      name: gatewaySku
      tier: gatewaySku
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    vpnClientConfiguration: {
      vpnClientAddressPool: {
        addressPrefixes: [
          vpnClientAddressPool
        ]
      }
      vpnClientProtocols: [
        'OpenVPN'
      ]
      vpnAuthenticationTypes: [
        'AAD'
      ]
      aadTenant: tenant
      aadAudience: audience
      aadIssuer: issuer
    }
  }
}
