#!/bin/bash
#remember to use sudo
#for use in ubuntu-based distros

# Check for root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Don't persist /var/log
TMPLOGDIR="tmpfs	/var/log	tmpfs	defaults,noatime,nodiratime,nodev,nosuid,noexec,size=100M	0 0"
sudo rm -rf /var/log/*
echo ${TMPLOGDIR} >> /etc/fstab

# Don't persist /tmp
TMPDIR="tmpfs	/tmp	tmpfs	defaults,noatime,nodiratime,nodev,nosuid,noexec,size=100M	0 0"
sudo rm -rf /tmp/*
echo ${TMPDIR} >> /etc/fstab

mount -a

# Make Linux rely less on swap space
echo "vm.swappiness = 10" >> /etc/sysctl.conf
sysctl -p

# Remove guest account
if [ -f /etc/lightdm/lightdm.conf ]; then
	echo "\nallow-guest=false" >> /etc/lightdm/lightdm.conf
fi

# Enable default firewall settings
sudo ufw enable

# Disable recommended packages for apt
echo 'APT::Install-Recommends "false";' >> /etc/apt/apt-conf.d/99_norecommends
echo 'APT::AutoRemove::RecommendsImportant "false";' >> /etc/apt/apt-conf.d/99_norecommends
echo 'APT::AutoRemove::SuggestsImportant "false";' >> /etc/apt/apt-conf.d/99_norecommends
