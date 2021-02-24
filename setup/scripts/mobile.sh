#!/bin/bash

apt-get update

# Install python3
apt-get install -y python3 python3-pip

# Install frida and objection
pip3 install --no-cache-dir --upgrade objection frida frida-tools
