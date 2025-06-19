#!/bin/bash

echo "Starte Update und Upgrade..."

# Paketlisten aktualisieren
sudo apt-get update

# Verfügbare Updates anzeigen
echo "Verfügbare Updates:"
apt-get --just-print upgrade | grep -E 'Inst '

# Prüfen, ob Updates verfügbar sind
updates=$(apt-get --just-print upgrade | grep -E 'Inst ')

if [ -n "$updates" ]; then
    echo "Updates werden installiert..."
    sudo apt-get upgrade -y
    echo "Upgrade abgeschlossen."
else
    echo "Keine Updates verfügbar."
fi
