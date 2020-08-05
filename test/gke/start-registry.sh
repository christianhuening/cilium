#!/bin/bash

set -e
set -x

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker run -d \
	--restart=always \
	-v /opt/registry/certs:/certs \
	-e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
	-e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
	-e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
	-p 443 \
	registry:2 > ${script_dir}/registry_container

docker inspect "$(cat registry_container)" | jq -r '.[0]["NetworkSettings"]["Ports"]["443/tcp"][0]["HostPort"]' > ${script_dir}/registry_port

cat /etc/docker/daemon.json | jq -r ". + {\"insecure-registries\": (.[\"insecure-registries\"] + [\"$(${script_dir}/registry-ip.sh)\"])}" > /etc/docker/daemon.json
pgrep dockerd | xargs kill -SIGHUP
