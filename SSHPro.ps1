param(
    [string]$accion
)

. "$PSScriptRoot\funciones.ps1"

if (-not $accion) {
    Write-Host "`n"
    Write-Host "---------------------------------------------"
    Write-Host "---------- MENU SCRIPT SSH SERVER -----------"
    Write-Host "---------------------------------------------`n"
    Write-Host "Para verificar el estado del servicio:"
    Write-Host ".\SSHPro.ps1 -accion verificar`n"
    Write-Host "Para re/instalar el paquete:"
    Write-Host ".\SSHPro.ps1 -accion instalar`n"
}

switch ($accion) {
    "verificar" {
        Verificar-Paquete "OpenSSH.Server"
    }
    "instalar" {
        Write-Host "Re/Instalacion de Paquetes:`n"
        Instalar-Paquete "OpenSSH.Server"
    }
}