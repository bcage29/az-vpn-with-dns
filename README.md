# Create a Point-to-Site VPN with Entra ID Authentication

## Summary
Creating a VPN into your VNET *used* to be complicated. Click the "Deploy to Azure" button below to create a VPN to your VNET in a few minutes. Now you don't have to think about if you should enable public access to that database, go ahead and create resources with ONLY private access.

[![Deploy To Azure](https://raw.githubusercontent.com/bcage29/devAzVPN/main/quickDeploy/deploytoazure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fbcage29%2FdevAzVPN%2Fmain%2FquickDeploy%2Fazuredeploy.json)

## Learn more
- [Point-to-Site VPN with Entra ID Authentication](https://learn.microsoft.com/en-us/azure/vpn-gateway/point-to-site-entra-gateway)
- [Deploy Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-vscode)

## Steps to deploy
- Click the "Deploy to Azure" button or clone this repository and deploy the main.bicep file
- After the VPN Gateway has deployed succesfully, follow these [steps](https://learn.microsoft.com/en-us/azure/vpn-gateway/point-to-site-entra-gateway#download) to configure the VPN

