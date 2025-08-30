if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$u = "https://cdn.zabbix.com/zabbix/binaries/stable/7.4/7.4.2/zabbix_agent2-7.4.2-windows-amd64-openssl-static.zip"
$z = "$env:TEMP\z.zip"
$p = "C:\Program Files\ZabbixAgent2"
$c = "$p\conf\zabbix_agent2.conf"
$h = $env:COMPUTERNAME

# Criar pasta TEMP se necessário
md $env:TEMP -Force > $null

# Baixar ZIP
Invoke-WebRequest $u -OutFile $z -ErrorAction SilentlyContinue

# Parar serviço se já existir
if (Get-Service -Name "Zabbix Agent 2" -ErrorAction SilentlyContinue) {
    Stop-Service "Zabbix Agent 2" -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    & "$p\bin\zabbix_agent2.exe" --config $c --uninstall > $null 2>&1
    Start-Sleep -Seconds 2
}

# Extrair com -Force, suprimindo erros
try {
    Expand-Archive $z -DestinationPath $p -Force -ErrorAction Stop
} catch {}

# Editar config
(gc $c) | % {
    $_ -replace '^Server=.*', 'Server=192.168.0.105' `
       -replace '^ServerActive=.*', 'ServerActive=192.168.0.105' `
       -replace '^Hostname=.*', "Hostname=$h"
} | sc $c

# Instalar e iniciar serviço
& "$p\bin\zabbix_agent2.exe" --config $c --install > $null 2>&1
Start-Service "Zabbix Agent 2" -ErrorAction SilentlyContinue
Set-Service "Zabbix Agent 2" -StartupType Automatic

# Criar regra de firewall (se não existir)
if (-not (Get-NetFirewallRule -DisplayName "Zabbix Agent2" -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -DisplayName "Zabbix Agent2" -Direction Inbound -Protocol TCP -LocalPort 10050 -Action Allow > $null
}
