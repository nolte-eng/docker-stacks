#!/bin/bash
set -e  # Skript abbrechen bei Fehlern

# Locale vorbereiten
#export DEBIAN_FRONTEND=noninteractive
#apt-get update && apt-get install -y --no-install-recommends locales apt-utils

#export LANGUAGE=en_US.UTF-8
#export LANG=en_US.UTF-8
#localedef -i en_US -f UTF-8 en_US.UTF-8 || true
#localedef -i en_US -f ISO-8859-1 en_US.ISO-8859-1 || true

#echo "LANG=en_US.UTF-8" > /etc/default/locale
#update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
export PIP_ROOT_USER_ACTION=ignore
echo "[Entrypoint] Umgebung vorbereitet. Installiere Modulabhängigkeiten..."

## Charset-Normalizer sauber drüber installieren (ohne Deinstallation)
#pip3 install  --break-system-packages charset_normalizer --ignore-installed

# Alle requirements.txt aus extra-addons installieren
for dir in /mnt/extra-addons/*; do
    if [ -d "$dir" ] && [ -f "$dir/requirements.txt" ]; then
        echo "[Entrypoint] Installing requirements for module: $(basename "$dir")"
        pip3 install --break-system-packages -r "$dir/requirements.txt"
    fi
done

# Pip-Cache bereinigen
#pip3 cache purge || true


echo "[Entrypoint] Aktualisiere Odoo-Module: $CUSTOM_MODULES"
# odoo -c /etc/odoo/odoo.conf -u all  --stop-after-init

echo "[Entrypoint] Starte Odoo-Server..."
exec python3 /usr/bin/odoo -c /etc/odoo/odoo.conf
