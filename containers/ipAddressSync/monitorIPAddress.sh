#!/bin/bash
update_ip()
{
    container_ip=$(az container show -n $CONTAINER_GROUP_NAME -g $RESOURCE_GROUP_NAME --query ipAddress.ip --output tsv)
    timestamp=$(date)
    dns_ip="$(az network vnet show -g $RESOURCE_GROUP_NAME -n $VNET_NAME --query dhcpOptions.dnsServers --output tsv)"
    echo 'Checking IP on' $timestamp
    echo 'DNS IP: ' $dns_ip
    echo 'Container IP: ' $container_ip
    if [ "$container_ip" != "" ]; then
        if [ "$dns_ip" != "$container_ip" ]; then
            echo 'Updating DNS Servers'
            az network vnet update -g $RESOURCE_GROUP_NAME -n $VNET_NAME --dns-servers $container_ip
        else
            echo 'IP has not changed - skipping update'
        fi
    fi
}
az --version
az login --identity --output none

killed=0
while [ $killed -eq 0 ];
do
    update_ip &
    sleep 60
done