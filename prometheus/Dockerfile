ARG VERSION=v3.2.1

FROM prom/prometheus:${VERSION}

# Copy the prom.yml configuration file to the container
COPY prom.yml /etc/prometheus/prom.yml

# Copy the deployment script
COPY deploy.sh /usr/local/bin/deploy.sh
RUN chmod +x /usr/local/bin/deploy.sh

# Expose the port
EXPOSE 9090

# Railway will set PORT environment variable dynamically
# ENV PORT=9090

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:${PORT}/-/healthy || exit 1

# Use the deployment script as entrypoint
ENTRYPOINT ["/usr/local/bin/deploy.sh"]

# Ensure Prometheus uses our configuration file
CMD ["--config.file=/etc/prometheus/prom.yml", "--storage.tsdb.path=/prometheus", "--web.console.libraries=/etc/prometheus/console_libraries", "--web.console.templates=/etc/prometheus/consoles", "--web.enable-lifecycle", "--web.listen-address=0.0.0.0:9090"]