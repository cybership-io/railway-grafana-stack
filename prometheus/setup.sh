#!/bin/sh

set -e

PROMETHEUS_TARGET=${PROMETHEUS_TARGET:-server.railway.internal:3000}
PROMETHEUS_USER=${PROMETHEUS_USER:-admin}
PROMETHEUS_PASSWORD=${PROMETHEUS_PASSWORD:-admin}

echo "=========================================="
echo "Prometheus Setup Script Starting"
echo "=========================================="
echo "Starting Prometheus with user: $PROMETHEUS_USER"
echo "Password length: ${#PROMETHEUS_PASSWORD} characters"
echo "PORT environment variable: ${PORT:-9090}"
echo "Target: $PROMETHEUS_TARGET"

if ! command -v python3 >/dev/null 2>&1; then
    echo "ERROR: python3 not found"
    exit 1
fi

echo "Python3 found: $(which python3)"
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
    echo "ERROR: Failed to generate password hash"
    exit 1
fi

echo "✓ Bcrypt hash generated successfully"
echo "Hash starts with: $(echo $HASH | cut -c1-10)..."
echo ""
echo "Creating web config..."
mkdir -p /prometheus/config
cat > /prometheus/config/web-config.yml << EOF
basic_auth_users:
  ${PROMETHEUS_USER}: ${HASH}
EOF

if [ -f /prometheus/config/web-config.yml ]; then
    echo "✓ Web config created successfully at /prometheus/config/web-config.yml"
    echo "Web config contents:"
    cat /prometheus/config/web-config.yml
    echo ""
else
    echo "ERROR: Failed to create web config file"
    exit 1
fi


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

if [ -f /etc/prometheus/prom.yml ]; then
    echo "✓ Prometheus configuration generated successfully at /etc/prometheus/prom.yml"
    echo "Config file line count: $(wc -l < /etc/prometheus/prom.yml)"
else
    echo "ERROR: Failed to create prometheus config file"
    exit 1
fi
echo ""

echo "Setting up authentication secrets..."
mkdir -p /etc/prometheus/secrets
if [ -n "$PROMETHEUS_AUTH_TOKEN" ]; then
    echo "$PROMETHEUS_AUTH_TOKEN" > /etc/prometheus/secrets/token
    chmod 600 /etc/prometheus/secrets/token
    echo "✓ Auth token configured (length: ${#PROMETHEUS_AUTH_TOKEN} characters)"
else
    touch /etc/prometheus/secrets/token
    echo "⚠ No auth token provided (PROMETHEUS_AUTH_TOKEN not set)"
fi

echo ""
echo "=========================================="
echo "✓ Authentication setup complete"
echo "=========================================="
echo "Username: $PROMETHEUS_USER"
echo "Password: [CONFIGURED - ${#PROMETHEUS_PASSWORD} chars]"
echo "Web config: /prometheus/config/web-config.yml"
echo "Prom config: /etc/prometheus/prom.yml"
echo "=========================================="
echo ""
echo "Starting Prometheus server..."