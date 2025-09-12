#!/bin/sh
mkdir -p /etc/grafana/provisioning/dashboards/files

DASHBOARDS="api-debugging api-key-metrics app-overview business-metrics database-connections database-metrics integrations-metrics queue-metrics system-health-overview error-debugging performance-debugging redis-metrics"
BASE_URL="https://s3.us-east-1.amazonaws.com/cdn.cybership.dev/observability/dashboards/json"

for dashboard in $DASHBOARDS; do
  echo "Downloading ${dashboard}.json..."
  curl -f -o "/etc/grafana/provisioning/dashboards/files/${dashboard}.json" \
    "${BASE_URL}/${dashboard}.json" || echo "Failed to download ${dashboard}.json"
done