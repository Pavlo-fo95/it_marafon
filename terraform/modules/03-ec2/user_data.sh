#!/bin/bash
set -eux

# пример под Ubuntu; под Amazon Linux заменить apt-get на yum
if ! command -v docker &>/dev/null; then
  apt-get update -y || yum update -y
  apt-get install -y docker.io || yum install -y docker
  systemctl enable docker
  systemctl start docker
fi

BACKEND_IMAGE="${docker_backend_image}"
FRONT_IMAGE="${docker_front_image}"

docker rm -f secret-nick-api || true
docker rm -f secret-nick-front || true

docker pull "$BACKEND_IMAGE" || true
docker pull "$FRONT_IMAGE" || true

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
    # сюда можно потом добавить образ для Angular, если будет
    ;;
esac
