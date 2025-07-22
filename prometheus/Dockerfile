ARG VERSION=v3.2.1

FROM prom/prometheus:${VERSION}

# Copy the prom.yml configuration file to the container
COPY prom.yml /etc/prometheus/prom.yml

# Expose the port
EXPOSE 9090

# Set default PORT environment variable
ENV PORT=9090