
#!/bin/bash

echo "Aktualisiere Paketlisten (inkl. Sicherheitsupdates)..."
apt update -o Dir::Etc::sourcelist="sources.list.d/debian-security.list" \
           -o Dir::Etc::sourceparts="-" \
           -o APT::Get::List-Cleanup="0"

echo "Installiere nur Sicherheitsupdates..."
apt list --upgradable 2>/dev/null | grep -i security

apt upgrade --with-new-pkgs --only-upgrade \
     -o Dir::Etc::sourcelist="sources.list.d/debian-security.list" \
     -o Dir::Etc::sourceparts="-" \
     -o APT::Get::List-Cleanup="0" -y
