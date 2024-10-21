FROM mcr.microsoft.com/azure-cli AS base

LABEL org.opencontainers.image.source https://github.com/bcage29/devAzVPN

COPY monitorIPAddress.sh /app/

RUN chmod +x /app/monitorIPAddress.sh

ENTRYPOINT ["/app/monitorIPAddress.sh"]
