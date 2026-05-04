#!/bin/bash
set -e

# ----- Original: Passwort aus Datei -----
if [ -v PASSWORD_FILE ]; then
    PASSWORD="$(< $PASSWORD_FILE)"
fi

# ----- Original: DB-Variablen / Defaults -----
: ${HOST:=${DB_PORT_5432_TCP_ADDR:='db'}}
: ${PORT:=${DB_PORT_5432_TCP_PORT:=5432}}
: ${USER:=${DB_ENV_POSTGRES_USER:=${POSTGRES_USER:='odoo'}}}
: ${PASSWORD:=${DB_ENV_POSTGRES_PASSWORD:=${POSTGRES_PASSWORD:='odoo'}}}

DB_ARGS=()
function check_config() {
    param="$1"
    value="$2"
    if grep -q -E "^\s*\b${param}\b\s*=" "$ODOO_RC" ; then
        value=$(grep -E "^\s*\b${param}\b\s*=" "$ODOO_RC" | cut -d " " -f3 | sed 's/["\n\r]//g')
    fi
    DB_ARGS+=("--${param}")
    DB_ARGS+=("${value}")
}
check_config "db_host" "$HOST"
check_config "db_port" "$PORT"
check_config "db_user" "$USER"
check_config "db_password" "$PASSWORD"

# ====== EINZIGE NEUERUNGEN (Enterprise only) ======
#echo "[Entrypoint] Installing common Enterprise Python deps..."
#python3 -m pip install --break-system-packages -U pip setuptools wheel || true
#pip3 install --break-system-packages "paramiko<3" "pysftp==0.2.9" || true
#python3 -m pip install --break-system-packages \
#  google-auth google-auth-oauthlib google-api-python-client \
#  msal msal-extensions boto3 azure-storage-blob google-cloud-storage || true

# requirements.txt in /mnt/enterprise installieren (falls vorhanden)
#if [ -d /mnt/enterprise ]; then
#  echo "[Entrypoint] Scanning /mnt/enterprise for requirements.txt..."
#  while IFS= read -r req; do
#    echo "[Entrypoint] pip install -r $req"
#    python3 -m pip install --break-system-packages -r "$req" || true
#  done < <(find /mnt/enterprise -maxdepth 2 -type f -name requirements.txt 2>/dev/null)
#fi
# ====== /NEUERUNGEN ======

case "$1" in
    -- | odoo)
        shift
        if [[ "$1" == "scaffold" ]] ; then
            exec odoo "$@"
        else
            wait-for-psql.py ${DB_ARGS[@]} --timeout=30
            exec odoo "$@" "${DB_ARGS[@]}"
        fi
        ;;
    -*)
        wait-for-psql.py ${DB_ARGS[@]} --timeout=30
        exec odoo "$@" "${DB_ARGS[@]}"
        ;;
    *)
        exec "$@"
esac

exit 1
