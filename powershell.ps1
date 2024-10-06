
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Need to run as Admin!" -ForegroundColor Red
    Exit
}

$timezone = "Eastern Standard Time"
Set-TimeZone -Id $timezone
Write-Host "Time Zone set to $timezone"

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Write-Host "Firewall turned off"

(Get-WmiObject -class "Win32_TerminalServiceSetting" -Namespace root\cimv2\TerminalServices).SetAllowTSConnections(1)
Write-Host "Remote Desktop turned on"

powercfg -duplicatescheme SCHEME_MIN
Write-Host "Power plan set to High Performance"

$features = @("Web-Server", "Web-Common-Http", "Web-Asp-Net45", "Web-Net-Ext45")
foreach ($feature in $features) {
    Install-WindowsFeature -Name $feature -IncludeManagementTools
    Write-Host "Installed feature: $feature"
}

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1 -PropertyType Dword -Force
Write-Host "Auto updates turned off"

if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    Write-Host "Chocolatey installed"
}

$apps = @("googlechrome", "vscode", "7zip")
foreach ($app in $apps) {
    choco install $app -y
    Write-Host "Installed: $app"
}

Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Temp files cleaned up"

Write-Host "All done. Restarting in 10 seconds..."
Start-Sleep -Seconds 10
Restart-Computer
