#!/bin/sh

PROMETHEUS_USER=${PROMETHEUS_USER:-admin}

PROMETHEUS_PASSWORD=${PROMETHEUS_PASSWORD:-admin}

cat > /etc/prometheus/web-config.yml << EOF
basic_auth_users:
  ${PROMETHEUS_USER}: $(htpasswd -nbB "" "${PROMETHEUS_PASSWORD}" | cut -d: -f2)
EOF

mkdir -p /etc/prometheus/secrets
if [ -n "$PROMETHEUS_AUTH_TOKEN" ]; then
    echo "$PROMETHEUS_AUTH_TOKEN" > /etc/prometheus/secrets/token
    chmod 600 /etc/prometheus/secrets/token
    chown 65534:65534 /etc/prometheus/secrets/token
else
    touch /etc/prometheus/secrets/token
fi

exec prometheus \
    --config.file=/etc/prometheus/prom.yml \
    --web.config.file=/etc/prometheus/web-config.yml \
    --storage.tsdb.path=/prometheus \
    --web.console.libraries=/etc/prometheus/console_libraries \
    --web.console.templates=/etc/prometheus/consoles \
    --web.enable-lifecycle \
    --web.listen-address=0.0.0.0:${PORT:-9090}
