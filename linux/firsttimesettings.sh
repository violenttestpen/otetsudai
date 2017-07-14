#!/bin/bash
#remember to use sudo
#for use in ubuntu-based distros

TMPLOGDIR="tmpfs	/var/log	tmpfs	defaults,noatime,nodiratime,nodev,nosuid,noexec,size=100M	0 0"
sudo rm -rf /var/log/*
echo ${TMPLOGDIR} >> /etc/fstab

TMPDIR="tmpfs	/tmp	tmpfs	defaults,noatime,nodiratime,nodev,nosuid,noexec,size=100M	0 0"
sudo rm -rf /tmp/*
echo ${TMPDIR} >> /etc/fstab

mount -a

echo "vm.swappiness = 10" >> /etc/sysctl.conf
sysctl -p

if [ -f /etc/lightdm/lightdm.conf ]; then
	echo "\nallow-guest=false" >> /etc/lightdm/lightdm.conf
fi

sudo ufw enable
