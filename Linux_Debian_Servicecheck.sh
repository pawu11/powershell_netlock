#!/bin/bash

services=(
  mysql
  postgresql
  nginx
  apache2
  ufw
  fail2ban
  postfix
  docker-ce
  docker.io
  wazuh-agent
  clamav
  elastic-agent
  netlock-rmm-agent-comm
  netlock-rmm-agent-health
  netlock-rmm-agent-remote
)

echo "Dienst-Status Prüfung:"

for service in "${services[@]}"; do
  if systemctl list-units --type=service | grep -q "${service}.service"; then
    status=$(systemctl is-active "$service")
    echo "$service: $status"
  else
    if pgrep -x "$service" >/dev/null; then
      echo "$service: läuft (Prozess gefunden)"
    else
      echo "$service: Dienst/Prozess nicht gefunden"
    fi
  fi
done

echo
echo "Laufende Docker-Container:"
if command -v docker >/dev/null 2>&1; then
  docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
else
  echo "Docker ist nicht installiert oder nicht im Pfad."
fi
