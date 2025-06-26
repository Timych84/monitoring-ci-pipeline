FROM alpine:3.22.0

# Install base tools
RUN apk update && apk add --no-cache \
  curl \
  gettext \
  tzdata \
  openssh \
  rsync

# Install Prometheus (includes promtool)
ENV PROMETHEUS_VERSION=2.54.1
RUN curl -LO "https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz" && \
    tar -xzf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz && \
    mv prometheus-${PROMETHEUS_VERSION}.linux-amd64/promtool /usr/local/bin/promtool && \
    rm -rf prometheus-${PROMETHEUS_VERSION}*

# Install Alertmanager (includes amtool)
ENV ALERTMANAGER_VERSION=0.27.0
RUN curl -LO "https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz" && \
    tar -xzf alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz && \
    mv alertmanager-${ALERTMANAGER_VERSION}.linux-amd64/amtool /usr/local/bin/amtool && \
    rm -rf alertmanager-${ALERTMANAGER_VERSION}*

# Verify
# RUN promtool --version && amtool --version

ENTRYPOINT ["/bin/sh"]
