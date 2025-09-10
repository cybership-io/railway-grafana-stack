#!/bin/sh

set -e  

PROMETHEUS_TARGET=${PROMETHEUS_TARGET:-server.railway.internal:3000}
PROMETHEUS_USER=${PROMETHEUS_USER:-admin}
PROMETHEUS_PASSWORD=${PROMETHEUS_PASSWORD:-admin}

echo "Starting Prometheus with user: $PROMETHEUS_USER"
echo "PORT environment variable: ${PORT:-9090}"

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


echo "Generating prometheus configuration..."
cat > /etc/prometheus/prom.yml << EOF
global:
  scrape_interval: 15s # Default scrape interval

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
    basic_auth:
      username: ${PROMETHEUS_USER}
      password: ${PROMETHEUS_PASSWORD}

  - job_name: "server"
    scheme: http
    static_configs:
      - targets: ["${PROMETHEUS_TARGET}"]
    metrics_path: /metrics
    authorization:
      type: Bearer
      credentials_file: /etc/prometheus/secrets/token
    scrape_interval: 15s
EOF

echo "Prometheus configuration generated successfully"

mkdir -p /etc/prometheus/secrets
if [ -n "$PROMETHEUS_AUTH_TOKEN" ]; then
    echo "$PROMETHEUS_AUTH_TOKEN" > /etc/prometheus/secrets/token
    chmod 600 /etc/prometheus/secrets/token
    echo "Auth token configured"
else
    touch /etc/prometheus/secrets/token
    echo "No auth token provided"
fi

echo "Authentication setup complete"