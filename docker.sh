#!/bin/bash
set -eux
apt-get update
apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
        python-minimal zip python-simplejson \
        gnupg2 \
        software-properties-common
apt-get remove docker docker-engine docker.io

curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh

# install docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# install docker-machine
curl -L "https://github.com/docker/machine/releases/download/v0.15.0/docker-machine-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-machine && \
    chmod +x /usr/local/bin/docker-machine

usermod -G docker vagrant
