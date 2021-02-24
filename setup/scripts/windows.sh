#!/bin/bash

apt-get update
mkdir -p /home/vagrant/windows

# Install dependencies
apt-get install -y python3 python3-pip

# Install crackmapexec
pip3 install --no-cache-dir crackmapexec

# Install nishang
git clone https://github.com/samratashok/nishang.git

# Add Microsoft apt repository
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Install powershell
# if [ ! `which pwsh` ]; then
#     echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-groovy-prod groovy main" > /etc/apt/sources.list.d/powershell.list \
#         && apt-get update \
#         && apt-get install -y powershell \
#         && pwsh -c "Update-Help"
# fi

# Install MSSQL common tools
# if [ ! `which sqlcmd` ]; then
# curl https://packages.microsoft.com/config/ubuntu/20.10/prod.list | tee /etc/apt/sources.list.d/msprod.list \
#     && apt-get update \
#     && ACCEPT_EULA=y apt-get install -y mssql-tools unixodbc-dev \
#     && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
# fi

# Install common SMB enumeration tools
# apt-get install -y \
#     enum4linux \
#     smbclient \
#     smbmap
