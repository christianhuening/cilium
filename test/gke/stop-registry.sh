#!/bin/bash

set -e

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker kill "$(cat ${script_dir}/registry_container)"
docker rm "$(cat ${script_dir}/registry_container)"
