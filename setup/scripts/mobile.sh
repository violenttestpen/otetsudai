#!/bin/bash

apt-get update

# Install python3
apt-get install -y python3 python3-pip

# Install pipx
pip3 install --user --no-cache-dir pipx

# Install frida and objection
pipx install --pip-args="--no-cache-dir" objection
pipx install --pip-args="--no-cache-dir" frida-tools
