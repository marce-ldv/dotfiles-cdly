if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
    Start-Process pwsh.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit 
}

Write-Output "Installing chocolatey"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
}

choco upgrade all -y
choco install starship --force -y
choco install jetbrainsmononf --force -y
choco install nano --force -y
choco install fzf --force -y

Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module -Name PSReadLine -Force -AllowPrerelease -SkipPublisherCheck
Install-Module -Name Terminal-Icons -Repository PSGallery -Force
Install-Module -Name PSFzf -scope CurrentUser -Force

If (Test-Path -Path "$PSScriptRoot\mods\install.ps1" ) {
    pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\mods\install.ps1"
}

pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\update.ps1"

Write-Host '*** CLOSE AND OPEN POWERSHELL AGAIN! ***';

Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');