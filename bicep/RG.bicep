targetScope='subscription'

param name string
param location string = deployment().location

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: '${name}-rg'
  location: location
}
