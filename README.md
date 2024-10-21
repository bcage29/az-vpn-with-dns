# Create a Point-to-Site VPN with Entra ID Authentication and DNS Resolution

## Summary
Creating a VPN into your VNET *used* to be complicated. Click the "Deploy to Azure" button below to create a VPN to your VNET in a few minutes. Now you don't have to think about if you should enable public access to that database, go ahead and create resources with ONLY private access.

[![Deploy To Azure](https://raw.githubusercontent.com/bcage29/devAzVPN/main/quickDeploy/deploytoazure.svg)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fbcage29%2FdevAzVPN%2Fmain%2FquickDeploy%2Fazuredeploy.json)

## What does this deploy?

- Virtual Network (VNET)
- Virtual Network Gateway (VPN)
- Public IP Address (Used by VPN)
- Container Instance Group (DNS Forwarder)
- User Assigned Managed Identity

### Why do I need a DNS Forwarder?

Once you are connected to your VPN, you will not be able to resolve DNS queries (ie nslookup mystorageaccount.blob.core.windows.net will return a public IP address). This is because the DNS server you are using is not aware of the private IP address of the storage account. The DNS Forwarder will resolve the DNS query to the private IP address of the storage account.

### How does this work?

The DNS Forwarder is a container instance that runs a simple [DNS server](./containers/dns/). The DNS server forwards all DNS queries to the Azure DNS server (168.63.129.16). The [second container instance](./containers/ipAddressSync/) runs a script every minute to check if the dns container IP address has changed. If the IP address has changed, the [monitorIPAdress.sh](./containers/ipAddressSync/monitorIPAddress.sh) script will update the VNET DNS Servers setting using the azure cli and managed identity for authentication. The VNET DNS Servers setting is used by the VPN Gateway to resolve DNS queries.

If you don't want to use the containers for DNS resolution and want a more robust solution, you can use [Azure Private DNS Resolver](https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview) to resolve DNS queries. If you deploy this resource, you will need to create an Inbound Endpoint. Once that endpoint is provisioned, you can update the VNET DNS Servers setting to use the Private DNS Resolver Inbound Endpoint Private IP address.

## Steps to deploy
- Click the "Deploy to Azure" button above *or* clone this repository and deploy the [main.bicep](./infra/main.bicep) file
- Download the VPN client
    - Unzip the VPN client
    - Open 'Azure VPN Client' app and click 'Import'
    - Select the 'azurevpnconfig.xml' file
    - Connect to the VPN
    - For more detailed steps, refer to the [Point-to-Site documentation](https://learn.microsoft.com/en-us/azure/vpn-gateway/point-to-site-entra-gateway#download)

## Container Images

The two containers I am using for [DNS](https://ghcr.io/bcage29/az-dns-forwarder:latest) and [IP Sync](https://ghcr.io/bcage29/az-dns-forwarder/ip-sync:latest) are available on GitHub Container Registry and free for use. If you want to build your own images, the source code is available in the [containers](./containers) directory. 


Format for pushing to github container registry `ghcr.io/OWNER/IMAGE_NAME:TAG`

```bash
# dns
docker build ./containers/dns/ -t ghcr.io/bcage29/az-dns-forwarder:latest --platform linux/amd64

docker push ghcr.io/bcage29/az-dns-forwarder:latest

# ip sync
docker build ./containers/ipAddressSync/ -t ghcr.io/bcage29/az-dns-forwarder/ip-sync:latest --platform linux/amd64

docker push ghcr.io/bcage29/az-dns-forwarder/ip-sync:latest
```

## Learn more
- [Point-to-Site VPN with Entra ID Authentication](https://learn.microsoft.com/en-us/azure/vpn-gateway/point-to-site-entra-gateway)
- [Deploy Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-vscode)
- [Azure Quickstart Templates - DNS Forwarder](https://github.com/Azure/azure-quickstart-templates/tree/master/demos/dns-forwarder)
    - This is the original quickstart template that I modified to be containerized