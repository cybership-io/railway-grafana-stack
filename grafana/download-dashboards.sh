#!/bin/sh
mkdir -p /etc/grafana/provisioning/dashboards/files

DASHBOARDS="api-key-metrics app-overview business-metrics database-metrics integrations-metrics queue-metrics shipping-observability"
BASE_URL="https://s3.us-east-1.amazonaws.com/cdn.cybership.dev/observability/dashboards/json"

for dashboard in $DASHBOARDS; do
  echo "Downloading ${dashboard}.json..."
  curl -f -o "/etc/grafana/provisioning/dashboards/files/${dashboard}.json" \
    "${BASE_URL}/${dashboard}.json" || echo "Failed to download ${dashboard}.json"
done