#!/bin/bash

echo "Creating log dirs..."

for path in /etc/services.d/*; do
    [ -d "${path}" ] || continue
    dirname="$(basename "${path}")"
    mkdir -p "/var/log/services/${dirname}"
done

chown -R nobody:nogroup /var/log/services
