#!/bin/bash

log() {
    echo "$(date) - $1"
}

update_ip() {
    container_ip=$(az container show -n "$CONTAINER_GROUP_NAME" -g "$RESOURCE_GROUP_NAME" --query ipAddress.ip --output tsv)
    if [ $? -ne 0 ]; then
        log "Failed to get container IP"
        return 1
    fi

    dns_ip=$(az network vnet show -g "$RESOURCE_GROUP_NAME" -n "$VNET_NAME" --query dhcpOptions.dnsServers --output tsv)
    if [ $? -ne 0 ]; then
        log "Failed to get DNS IP"
        return 1
    fi

    log "Checking IP"
    log "DNS IP: $dns_ip"
    log "Container IP: $container_ip"

    if [ -n "$container_ip" ]; then
        if [ "$dns_ip" != "$container_ip" ]; then
            log "Updating DNS Servers"
            az network vnet update -g "$RESOURCE_GROUP_NAME" -n "$VNET_NAME" --dns-servers "$container_ip"
            if [ $? -ne 0 ]; then
                log "Failed to update DNS servers"
                return 1
            fi
        else
            log "IP has not changed - skipping update"
        fi
    fi
}

login_az() {
    az --version
    az login --identity --output none
    if [ $? -ne 0 ]; then
        log "Azure login failed"
        exit 1
    fi
}

main() {
    login_az

    while true; do
        update_ip
        sleep 60
    done
}

main