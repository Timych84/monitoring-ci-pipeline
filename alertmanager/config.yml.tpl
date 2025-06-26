global:
  smtp_smarthost: '${ALERTMANAGER_SMTP_HOST}'
  smtp_from: '${ALERTMANAGER_SMTP_FROM}'
  smtp_auth_username: '${ALERTMANAGER_SMTP_USER}'
  smtp_auth_password: '${ALERTMANAGER_SMTP_PASSWORD}'
  smtp_require_tls: false

time_intervals:
  - name: "working_hours"
    time_intervals:
    - weekdays: ['monday:friday']
      times:
        - start_time: "10:00"
          end_time: "20:00"
      location: "Europe/Moscow"
  - name: "non_working_hours"
    time_intervals:
    - weekdays: ['monday:friday']
      times:
        - start_time: "20:00"
          end_time: "24:00"
        - start_time: "00:00"
          end_time: "10:00"
      location: "Europe/Moscow"
    - weekdays: ['saturday','sunday']
      location: "Europe/Moscow"

route:
  receiver: 'email'
  group_by: ['alertname', 'job']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 3h
  routes:

    - matchers:
        - severity = "info"
      receiver: "telegram"
      active_time_intervals: ["working_hours"]
      continue: true
    - matchers:
        - severity = "info"
      receiver: "email"
      active_time_intervals: ["working_hours"]

    - matchers:
        - severity = "warning"
      receiver: "telegram"
      active_time_intervals: ["working_hours"]
      continue: true
    - matchers:
        - severity = "warning"
      receiver: "email"
      active_time_intervals: ["working_hours"]

    - matchers:
        - severity = "critical"
      receiver: "telegram"
      continue: true
    - matchers:
        - severity = "critical"
      receiver: "email"

    - matchers:
        - severity = "emergency"
      receiver: "telegram"
      continue: true
    - matchers:
        - severity = "emergency"
      receiver: "email"

receivers:
- name: 'email'
  email_configs:
  - to: '${ALERTMANAGER_SMTP_TO}'
    send_resolved: true
    headers:
      subject: "[{{ .Status }}] {{ .CommonLabels.alertname }}"
    text: |
      Alert: {{ .CommonLabels.alertname }}
      Severity: {{ .CommonLabels.severity }}
      Description: {{ .CommonAnnotations.description }}
      Instance: {{ .CommonLabels.instance }}
- name: 'telegram'
  telegram_configs:
  - chat_id: ${ALERTMANAGER_TELEGRAM_CHAT_ID}
    bot_token: '${ALERTMANAGER_TELEGRAM_BOT_TOKEN}'
    send_resolved: true
    message: |
      {{ range .Alerts }}
      {{ if eq .Labels.severity "info" }}
      🔹 <b>INFO</b>
      {{ else if eq .Labels.severity "warning" }}
      ⚠️ <b>WARNING</b>
      {{ else if eq .Labels.severity "critical" }}
      🚨 <b>CRITICAL</b>
      {{ else if eq .Labels.severity "emergency" }}
      🚨🚨 <b>EMERGENCY</b> 🚨🚨
      {{ end }}
      {{ if eq .Status "firing" }}
      🔴 <i>Firing</i>
      {{ else if eq .Status "resolved" }}
      🟢 <i>Resolved</i>
      {{ end }}
      Alert: {{ .Labels.alertname }}
      Severity: <b>{{ .Labels.severity }}</b>
      Description: {{ .Annotations.description }}
      Instance: {{ .Labels.instance }}
      Custom: {{ .Annotations.customfield }}
      {{ end }}
