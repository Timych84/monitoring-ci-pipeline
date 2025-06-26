# Prometheus CI/CD Configuration

This repository contains configuration files and a GitLab CI/CD pipeline to validate and deploy Prometheus and Alertmanager configurations using Docker.

## Features

- Validates Prometheus rules and configuration with `promtool`
- Validates Alertmanager configuration using `amtool`
- Builds a custom Docker image with required tools
- Deploys validated configuration files to remote servers over SSH
- Reloads Prometheus and Alertmanager automatically via HTTP API

## Requirements

- GitLab Runner with Docker executor
- SSH access to target Prometheus and Alertmanager hosts
- Docker registry access for pushing the custom validation image

## CI/CD Stages

### 🔨 `build`
Builds a Docker image with validation tools and pushes it to your container registry.

### ✅ `validate`
- Renders `alertmanager/config.yml` from template using `envsubst`
- Validates Alertmanager config with `amtool`
- Validates Prometheus config and rules with `promtool`

### 🚀 `deploy`
- Copies config files to remote servers using `rsync` over SSH
- Sends reload signals to Prometheus (`:9090/-/reload`) and Alertmanager (`:9093/-/reload`)

## Environment Variables

You must define these CI/CD variables in GitLab:

| Variable | Description |
|----------|-------------|
| `SSH_PRIVATE_KEY` | Private SSH key for connecting to the servers(stored as base64) |
| `SERVER_USER` | SSH username |
| `SERVER_HOST` | Target server address |
| `SERVER_PORT` | SSH port  |
| `SERVER_PROM_PATH` | Remote path for Prometheus configs |
| `SERVER_ALERTMANAGER_PATH` | Remote path for Alertmanager config |

Also you must define these Alertmanager parameters(used in Alertmanager config template) via CI/CD variables in Gitlab:
| Variable | Description |
|----------|-------------|
| `ALERTMANAGER_SMTP_HOST` | SMTP Host for sending mail notifications |
| `ALERTMANAGER_SMTP_FROM` | Email address from which notifications will be sent |
| `ALERTMANAGER_SMTP_USER` | SMTP user for sending mail notifications |
| `ALERTMANAGER_SMTP_PASSWORD` | SMTP password for sending mail notifications  |
| `ALERTMANAGER_SMTP_TO` | Email address or addresses for sending mail notifications |
| `ALERTMANAGER_TELEGRAM_CHAT_ID` | Telegram chat id for sending notifications via Telegram |
| `ALERTMANAGER_TELEGRAM_BOT_TOKEN` |Telegram token for sending notifications via Telegram |
