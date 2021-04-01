#!/bin/bash

apt-get update
apt-get install -y socat tmux openvpn

# Install zsh as our default shell
apt-get install -y curl git locales zsh fonts-powerline \
    && sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || echo true \
    && sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' /root/.zshrc \
    && chsh -s /usr/bin/zsh

# Install common tools
apt-get install -y \
    net-tools \
    man-db \
    vim less \
    ca-certificates git curl \
    zip unzip \
    openssh-client

# Install common runtime languages
apt-get install -y python3 python3-pip

# Install shellerator and One-Lin3r for easy reverse shell generations
pip3 install --no-cache-dir \
    git+https://github.com/ShutdownRepo/shellerator.git \
    git+https://github.com/D4Vinci/One-Lin3r.git

# Install jwt_tool
if [ ! -d /home/vagrant/jwt_tool ]; then
    git clone https://github.com/ticarpi/jwt_tool.git /home/vagrant/jwt_tool
    pip3 install --no-cache-dir termcolor cprint pycryptodomex requests
    chmod +x /home/vagrant/jwt_tool/jwt_tool.py
fi