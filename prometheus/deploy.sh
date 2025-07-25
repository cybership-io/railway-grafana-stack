#!/bin/bash

# Deployment script for Prometheus with auth token setup
# This script runs before Prometheus starts to create the auth token file

set -e

echo "🚀 Starting Prometheus deployment setup..."

# Create the secrets directory if it doesn't exist
echo "📁 Creating secrets directory..."
mkdir -p /etc/prometheus/secrets

# Check if the auth token environment variable is set
if [ -z "$PROMETHEUS_AUTH_TOKEN" ]; then
    echo "⚠️  Warning: PROMETHEUS_AUTH_TOKEN environment variable is not set"
    echo "   Prometheus will run without authentication"
    # Create an empty token file to prevent Prometheus errors
    touch /etc/prometheus/secrets/token
else
    echo "🔐 Writing auth token to file..."
    # Write the token to the file
    echo "$PROMETHEUS_AUTH_TOKEN" > /etc/prometheus/secrets/token
    
    # Set proper permissions (read-only for Prometheus)
    chmod 600 /etc/prometheus/secrets/token
    chown 65534:65534 /etc/prometheus/secrets/token  # nobody:nobody (Prometheus user)
    
    echo "✅ Auth token file created successfully"
fi

echo "🎉 Prometheus deployment setup completed!"

# Start Prometheus with the original command
exec "$@" 