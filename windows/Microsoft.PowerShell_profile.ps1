# function Invoke-Starship-PreCommand {
#     $host.ui.Write("🚀 ")
#     $host.ui.Write($env:UserName + " ")
#     $host.ui.Write((Invoke-WebRequest -uri "http://ifconfig.me/ip").Content)
# }

$env:STARSHIP_DISTRO = "視"
$env:IP = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content

Invoke-Expression (&starship init powershell)
