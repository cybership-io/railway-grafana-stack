#!/bin/sh

set -e  

PROMETHEUS_USER=${PROMETHEUS_USER:-admin}
PROMETHEUS_PASSWORD=${PROMETHEUS_PASSWORD:-admin}

echo "Starting Prometheus with user: $PROMETHEUS_USER"
echo "Starting Prometheus with password: $PROMETHEUS_PASSWORD"

if ! command -v python3 >/dev/null 2>&1; then
    echo "Error: python3 not found"
    exit 1
fi

echo "Generating bcrypt hash for password..."
HASH=$(python3 -c "
import bcrypt
import sys
try:
    password = '$PROMETHEUS_PASSWORD'.encode('utf-8')
    salt = bcrypt.gensalt()
    hash_bytes = bcrypt.hashpw(password, salt)
    print(hash_bytes.decode('utf-8'))
except Exception as e:
    print(f'Error generating hash: {e}', file=sys.stderr)
    sys.exit(1)
")

if [ -z "$HASH" ]; then
    echo "Error: Failed to generate password hash"
    exit 1
fi

echo "Creating web config..."

mkdir -p /prometheus/config
cat > /prometheus/config/web-config.yml << EOF
basic_auth_users:
  ${PROMETHEUS_USER}: ${HASH}
EOF

echo "Web config created successfully"

mkdir -p /prometheus/secrets
if [ -n "$PROMETHEUS_AUTH_TOKEN" ]; then
    echo "$PROMETHEUS_AUTH_TOKEN" > /prometheus/secrets/token
    chmod 600 /prometheus/secrets/token
    echo "Auth token configured"
else
    touch /prometheus/secrets/token
    echo "No auth token provided"
fi

echo "Starting Prometheus..."

exec prometheus \
    --config.file=/etc/prometheus/prom.yml \
    --web.config.file=/prometheus/config/web-config.yml \
    --storage.tsdb.path=/prometheus \
    --web.console.libraries=/etc/prometheus/console_libraries \
    --web.console.templates=/etc/prometheus/consoles \
    --web.enable-lifecycle \
    --web.listen-address=0.0.0.0:${PORT:-9090}