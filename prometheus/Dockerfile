ARG VERSION=v3.2.1

FROM prom/prometheus:${VERSION}

USER root
RUN apk add --no-cache apache2-utils

COPY prom.yml /etc/prometheus/prom.yml

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 9090

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider --auth-no-challenge \
    --user=${PROMETHEUS_USER:-admin} --password=${PROMETHEUS_PASSWORD:-admin} \
    http://localhost:${PORT:-9090}/-/healthy || exit 1

CMD ["/start.sh"]