#!/bin/bash

DDNS_DOMAIN="public.com"
CADDYFILE="/opt/containers/headscale/caddy/Caddyfile"

# Erhalte die aktuelle IP-Adresse von der DDNS-Domain
CURRENT_IP=$(dig +short $DDNS_DOMAIN)

# Prüfe, ob die aktuelle IP-Adresse gültig ist
if [[ -z "$CURRENT_IP" ]]; then
    echo "Fehler: Konnte die IP-Adresse von $DDNS_DOMAIN nicht ermitteln."
    exit 1
fi

# Ersetze den Platzhalter im Caddyfile durch die aktuelle IP-Adresse
sed -i "s/CURRENT_IP_PLACEHOLDER/$CURRENT_IP/" $CADDYFILE


# Starte Caddy neu, um die Änderungen zu übernehmen
docker compose -f /opt/containers/headscale/docker-compose.yml restart caddy

# Füge den Platzhalter zurück, um zukünftige Ersetzungen zu ermöglichen
sed -i "s/$CURRENT_IP/CURRENT_IP_PLACEHOLDER/" $CADDYFILE
