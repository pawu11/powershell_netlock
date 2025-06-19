#!/bin/bash

echo "=== Update-Prüfung ==="
sudo apt-get update -qq
#updates=$(apt-get --just-print upgrade | grep -E 'Inst ')

if [ -n "$updates" ]; then
    echo "!!! Es sind Updates verfügbar:"
    #echo "$updates"
else
    echo "Keine Updates verfügbar."
fi

echo
echo "=== Dienst-Status ==="

# ufw aktiv?
if systemctl is-active --quiet ufw; then
    echo "ufw Service ist gestartet."
else
    echo "!!! ufw Service ist NICHT gestartet."
fi

# fail2ban aktiv?
if systemctl is-active --quiet fail2ban; then
    echo "fail2ban läuft."
else
    echo "!!! fail2ban läuft NICHT."
fi

# wazuh-agent aktiv?
if systemctl is-active --quiet wazuh-agent; then
    echo "wazuh-agent läuft."
else
    echo "!!! wazuh-agent läuft NICHT."
fi

echo
echo "=== IP-Konfiguration ==="

# Prüfe, ob eine statische IP konfiguriert ist
# Das ist etwas tricky, wir prüfen ob in /etc/network/interfaces oder in netplan eine statische IP steht

if grep -q "iface.*static" /etc/network/interfaces 2>/dev/null; then
    echo "Statische IP-Konfiguration in /etc/network/interfaces gefunden."
else
    # Prüfen auf netplan (Ubuntu/Debian 12 kann netplan nutzen)
    if [ -d /etc/netplan ]; then
        static_ip=$(grep -R "dhcp4: no" /etc/netplan)
        if [ -n "$static_ip" ]; then
            echo "Statische IP-Konfiguration in /etc/netplan gefunden."
        else
            echo "Keine statische IP-Konfiguration in /etc/netplan gefunden (DHCP wahrscheinlich aktiv)."
        fi
    else
        echo "Keine statische IP-Konfiguration gefunden (Standard DHCP?)."
    fi
fi

echo
echo "=== Netzwerkverbindungstest ==="

# ping www.google.de
if ping -c 3 www.google.de &>/dev/null; then
    echo "Ping zu www.google.de erfolgreich."
else
    echo "!!! Ping zu www.google.de NICHT erfolgreich."
fi

# ping 8.8.8.8
if ping -c 3 8.8.8.8 &>/dev/null; then
    echo "Ping zu 8.8.8.8 erfolgreich."
else
    echo "!!! Ping zu 8.8.8.8 NICHT erfolgreich."
fi
