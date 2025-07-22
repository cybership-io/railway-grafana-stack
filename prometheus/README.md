# Prometheus Deployment on Railway

This directory contains the Prometheus monitoring configuration for Railway deployment.

## Files

- `dockerfile` - Docker configuration for Prometheus
- `prom.yml` - Prometheus configuration file
- `railway.json` - Railway deployment configuration
- `nixpacks.toml` - Alternative Nixpacks build configuration

## Deployment

1. Deploy this `prometheus` directory as a new Railway service
2. Railway will automatically detect the Dockerfile and configuration files
3. The service will be available on the assigned Railway domain

## Configuration

The Prometheus instance is configured to:

- Listen on port 9090 (or Railway's assigned PORT)
- Use the configuration from `prom.yml`
- Store data in `/prometheus` directory
- Enable the web UI and lifecycle management API

## Environment Variables

- `PORT` - The port to bind to (automatically set by Railway)

## Accessing

Once deployed, you can access:

- Prometheus Web UI: `https://your-service-name.up.railway.app`
- Metrics endpoint: `https://your-service-name.up.railway.app/metrics`
- Health check: `https://your-service-name.up.railway.app/-/healthy`
