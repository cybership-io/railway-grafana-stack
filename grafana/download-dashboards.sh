#!/bin/sh
mkdir -p /etc/grafana/provisioning/dashboards/files

BASE_URL="https://s3.us-east-1.amazonaws.com/cdn.cybership.dev/observability/dashboards/json"

DASHBOARDS=$(curl -s "${BASE_URL}/" | grep -oE '[^>]*\.json' | sed 's/\.json$//' | tr '\n' ' ')

for dashboard in $DASHBOARDS; do
  echo "Downloading ${dashboard}.json..."
  curl -f -o "/etc/grafana/provisioning/dashboards/files/${dashboard}.json" \
    "${BASE_URL}/${dashboard}.json" || echo "Failed to download ${dashboard}.json"
done