FROM alpine:latest

LABEL org.opencontainers.image.source https://github.com/bcage29/devAzVPN

# Copy the bind configuration files
ADD named.conf /etc/bind/

# Install bind DNS server
# --no-cache will not store it in index on the local machine
RUN apk add --no-cache bind

# 53 is the standard port for DNS queries and responses. 
# UDP is typically used for standard queries
# While TCP is used for larger queries and zone transfers.
# We are running in ACI and ports have to be unique
# Meaning we can't expose the same port twice for the different protocols
# So we are only exposing the UDP port
EXPOSE 53/udp

ENTRYPOINT ["/usr/sbin/named", "-f", "-g"]