ARG VERSION=v3.2.1

FROM alpine:3.18

ARG VERSION=v3.2.1

RUN apk add --no-cache \
    python3 \
    py3-pip \
    wget \
    ca-certificates \
    && pip3 install bcrypt --break-system-packages

RUN echo "Downloading Prometheus version: ${VERSION}" \
    && wget https://github.com/prometheus/prometheus/releases/download/${VERSION}/prometheus-${VERSION#v}.linux-amd64.tar.gz \
    && tar -xzf prometheus-${VERSION#v}.linux-amd64.tar.gz \
    && mv prometheus-${VERSION#v}.linux-amd64/prometheus /bin/prometheus \
    && mv prometheus-${VERSION#v}.linux-amd64/promtool /bin/promtool \
    && mkdir -p /etc/prometheus /prometheus \
    && if [ -d "prometheus-${VERSION#v}.linux-amd64/console_libraries" ]; then \
         mv prometheus-${VERSION#v}.linux-amd64/console_libraries /etc/prometheus/; \
       else \
         mkdir -p /etc/prometheus/console_libraries; \
       fi \
    && if [ -d "prometheus-${VERSION#v}.linux-amd64/consoles" ]; then \
         mv prometheus-${VERSION#v}.linux-amd64/consoles /etc/prometheus/; \
       else \
         mkdir -p /etc/prometheus/consoles; \
       fi \
    && rm -rf prometheus-${VERSION#v}.linux-amd64*

RUN chown -R nobody:nobody /etc/prometheus /prometheus

# COPY prom.yml /etc/prometheus/prom.yml
COPY setup.sh /setup.sh

RUN chmod +x /setup.sh4

USER nobody

EXPOSE 9090

CMD ["sh", "-c", "/setup.sh && prometheus --config.file=/etc/prometheus/prom.yml --web.config.file=/prometheus/config/web-config.yml --storage.tsdb.path=/prometheus --web.console.libraries=/etc/prometheus/console_libraries --web.console.templates=/etc/prometheus/consoles --web.enable-lifecycle --web.listen-address=0.0.0.0:${PORT:-9090}"]