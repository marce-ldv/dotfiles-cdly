$env:STARSHIP_DISTRO = "";
$env:IP = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content;

function updateShell {
    Set-Location ~/.dotfiles && pwsh update.ps1
}

Set-Alias -Name ushell -Value updateShell

function pullUpdateShell {
    Set-Location ~/.dotfiles && git pull && pwsh update.ps1
}

Set-Alias -Name pshell -Value pullUpdateShell

Invoke-Expression (&starship init powershell)