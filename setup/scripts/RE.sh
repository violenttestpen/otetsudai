#!/bin/bash

# Enable 32-bit support
apt-get update
apt-get install -y gcc-multilib

# Install dependencies
apt-get install -y git python3 python3-pip ruby

# Install pipx
pip3 install --user --no-cache-dir pipx

# Install pwntools
pip3 install --no-cache-dir pwntools

# Add checksec.sh
apt-get install -y dos2unix \
    && wget http://www.trapkit.de/tools/checksec.sh -O - | dos2unix > /usr/local/bin/checksec \
    && chmod +x /usr/local/bin/checksec

# Install gdb and gef
apt-get install -y gdb
if [ ! -f /home/vagrant/.gdbinit-gef.py ]; then
    wget -O /home/vagrant/.gdbinit-gef.py -q http://gef.blah.cat/py
    echo source /home/vagrant/.gdbinit-gef.py >> /home/vagrant/.gdbinit-gef
    pip3 install --no-cache-dir keystone-engine ropper
    echo 'alias gef="gdb -x $HOME/.gdbinit-gef"' >> /home/vagrant/.bashrc
fi

# Install pwndbg
if [ ! -d /home/vagrant/pwndbg ]; then
    git clone https://github.com/pwndbg/pwndbg.git
    (cd pwndbg && ./setup.sh)
fi

# Install radare2
if [ ! `which r2` ]; then
    git clone https://github.com/radare/radare2.git \
        && cd radare2 \
        && sys/install.sh \
        && rm -rf .git
fi

# Install radare2 packages
r2pm -gi r2dec

# Install one_gadget
gem install --no-document one_gadget

# Install frida
pipx install --pip-args="--no-cache-dir" frida-tools

# Install gostringsr2
pipx install --pip-args="--no-cache-dir" git+https://github.com/carvesystems/gostringsr2.git
