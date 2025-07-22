ARG VERSION=v3.2.1

FROM prom/prometheus:${VERSION}

# Copy the prom.yml configuration file to the container
COPY prom.yml /etc/prometheus/prom.yml

# Expose the port
EXPOSE 9090

# Set default PORT environment variable
ENV PORT=9090

# Command to run Prometheus with Railway-compatible settings
CMD ["sh", "-c", "prometheus --config.file=/etc/prometheus/prom.yml --storage.tsdb.path=/prometheus --web.console.libraries=/etc/prometheus/console_libraries --web.console.templates=/etc/prometheus/consoles --web.enable-lifecycle --web.listen-address=0.0.0.0:${PORT}"]