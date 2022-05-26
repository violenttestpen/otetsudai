#!/bin/bash

export TOOLS_DIR=/home/vagrant/tools

apt-get update
mkdir -p /home/vagrant/linux
mkdir -p /home/vagrant/.local/bin

# Install dependencies
apt-get install -y jq p7zip-full python3 python3-pip

# Install pipx
pip3 install --user --no-cache-dir pipx

# Install pwncat
pipx install --pip-args="--no-cache-dir" pwncat

# Install gobuster
# GOBUSTER_URL=`curl https://api.github.com/repos/OJ/gobuster/releases/latest | jq -r '.assets[] | select(.name | contains("gobuster-linux-amd64.7z")) | .browser_download_url'`

# Download linPEAS
mkdir -p $TOOLS_DIR
curl https://raw.githubusercontent.com/carlospolop/privilege-escalation-awesome-scripts-suite/master/linPEAS/linpeas.sh > $TOOLS_DIR/linpeas.sh
