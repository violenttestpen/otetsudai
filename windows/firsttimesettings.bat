REM Install chocolatey
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

REM Install my essential packages
choco install -y 7zip ^
		ccleaner ^
		deluge ^
		dropbox ^
		GoogleChrome ^
		keepass ^
		libreoffice ^
		telegram ^

REM Install my development tools
choco install -y docker-toolbox ^
		git ^
		notepadplusplus ^
		vagrant ^
		virtualbox ^
		VisualStudioCode ^
		Xming

REM Install python and my goto libraries
choco install -y python3
pip install --no-cache-dir pipdeptree ^
			requests ^
			httpie ^
			virtualenv

REM Install my pentest tools
REM choco install -y 