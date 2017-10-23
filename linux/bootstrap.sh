#!/bin/bash
#remember to use sudo
#for use in ubuntu-based distros

# https://www.codelitt.com/blog/my-first-10-minutes-on-a-server-primer-for-securing-ubuntu/

# Variables
USER=deploy
MY_IP=192.168.1.1

# First things firsst
passwd root
apt-get update
apt-get upgrade -y

# Add your user
useradd ${USER}
mkdir -p /home/${USER}/.ssh
chmod 700 /home/${USER}/.ssh
usermod -s /bin/bash ${USER}

# Require ssh key authentication
# vim /home/deploy/.ssh/authorized_keys
chmod 400 /home/${USER}/.ssh/authorized_keys
chown ${USER}:${USER} /home/${USER} -R

# Test user and setup sudo
passwd ${USER}
# visudo
usermod -aG sudo ${USER}

# Enforce ssh key logins
# vim /etc/ssh/sshd_config

# Setting up a firewall
# vim /etc/default/ufw
ufw allow from ${MY_IP} to any port 22
ufw allow 80
ufw allow 443
ufw disable
ufw enable

# Automated security updates
apt-get install -y unattended-upgrades
# vim /etc/apt/apt.conf.d/10periodic
# vim /etc/apt/apt.conf.d/50unattended-upgrades

# fail2ban
apt-get install -y fail2ban

# 2 Factor Authentication
# apt-get install libpam-google-authenticator
# google-authenticator

# Logwatch
apt-get install -y logwatch
# vim /etc/cron.daily/00logwatch