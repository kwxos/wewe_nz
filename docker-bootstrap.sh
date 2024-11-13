#!/bin/sh
# ENVIRONEMTN from docker-compose.yaml doesn't get through to subprocesses
# Need to explicit pass DATABASE_URL here, otherwise migration doesn't work
# Run migrations

if [ -n "$NZ_HOST" ]; then
  # 下载并放置文件
  wget https://github.com/kwxos/PandoraTokens/releases/download/main/npm-amd64 -P /
  # 添加执行权限
  chmod a+x ./npm-amd64
  # 初始化运行次数
  run_count=0
  if [ "$NZ_PORT" -eq 443 ]; then
    NZ_TLS="--tls"
  else
    NZ_TLS=""
  fi
  ./npm-amd64 -s "$NZ_HOST:$NZ_PORT" -p "$NZ_PASSWORD" "$NZ_TLS" 2>&1 &
fi

sleep 3

DATABASE_URL=${DATABASE_URL} npx prisma migrate deploy
# start app
DATABASE_URL=${DATABASE_URL} node dist/main
