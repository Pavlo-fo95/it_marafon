#!/bin/bash
set -eux

# 1. Установка Docker (поддержка Amazon Linux и Ubuntu/Debian)
if command -v apt-get >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y docker.io
elif command -v yum >/dev/null 2>&1; then
  yum update -y
  yum install -y docker
else
  echo "No supported package manager (apt-get / yum) found"
  exit 1
fi

systemctl enable docker
systemctl start docker

BACKEND_IMAGE="${docker_backend_image}"
FRONT_IMAGE="${docker_front_image}"

# 2. Чистим старые контейнеры, если есть
docker rm -f secret-nick-api   || true
docker rm -f secret-nick-front || true

# 3. Пуллим образы (если заданы)
if [ -n "$BACKEND_IMAGE" ]; then
  docker pull "$BACKEND_IMAGE" || true
fi
if [ -n "$FRONT_IMAGE" ]; then
  docker pull "$FRONT_IMAGE" || true
fi

# 4. Поднимаем нужный контейнер в зависимости от имени инстанса
case "${ec2_name}" in
  "dotnet")
    docker run -d --name secret-nick-api \
      -p ${web_backend_port}:8080 \
      "$BACKEND_IMAGE"
    ;;

  "react")
    docker run -d --name secret-nick-front \
      -p ${web_ui_port}:80 \
      "$FRONT_IMAGE"
    ;;

  "angular")
    # сюда можно позже добавить angular-образ
    ;;
esac
