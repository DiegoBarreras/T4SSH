function Verificar-Paquete {
    param($paq)
    Write-Host "Buscando el paquete $paq"

    $estado = Get-WindowsCapability -Online -Name $paq* | Select-Object -ExpandProperty State

    if ($estado -eq "Installed") {
        Write-Host "El paquete $paq fue instalado previamente.`n"
    }
    else {
        Write-Host "El paquete $paq no ha sido instalado.`n"
    }
}

function Prender-Servicio {
    param($servicio)
    Write-Host "Habilitando el servicio $servicio"
    Set-Service -Name $servicio -StartupType Automatic
    Start-Service -Name $servicio
    Write-Host "Servicio $servicio habilitado y activo.`n"
}

function Agregar-ReglaFirewall {
    Write-Host "Configurando regla de Firewall para el puerto 22:"
    $regla = Get-NetFirewallRule -Name "sshd" -ErrorAction SilentlyContinue
    if ($regla) {
        Write-Host "La regla de Firewall ya existe.`n"
    }
    else {
        New-NetFirewallRule -Name "sshd" -DisplayName "OpenSSH Server (sshd)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
        Write-Host "Regla de Firewall agregada correctamente.`n"
    }
}

function Instalar-Paquete {
    param($paq)
    Write-Host "Buscando el paquete $paq"

    $estado = Get-WindowsCapability -Online -Name $paq* | Select-Object -ExpandProperty State

    if ($estado -eq "Installed") {
        Write-Host "El paquete $paq fue instalado previamente.`n"
        $res = Read-Host "Deseas reinstalar el paquete $paq? s/n"
        if ($res -eq "s") {
            Write-Host "Reinstalando el paquete $paq.`n"
            Remove-WindowsCapability -Online -Name $paq~~~~0.0.1.0
            Add-WindowsCapability -Online -Name $paq~~~~0.0.1.0
            Prender-Servicio "sshd"
            Agregar-ReglaFirewall
        }
        else {
            Write-Host "La instalacion fue cancelada.`n"
        }
    }
    else {
        Write-Host "El paquete $paq no ha sido instalado.`n"
        $res = Read-Host "Deseas instalar el paquete $paq? s/n"
        if ($res -eq "s") {
            Write-Host "Instalando el paquete $paq.`n"
            Add-WindowsCapability -Online -Name $paq~~~~0.0.1.0
            Prender-Servicio "sshd"
            Agregar-ReglaFirewall
        }
        else {
            Write-Host "La instalacion fue cancelada.`n"
        }
    }
}

# --- MENU ---
param(
    [string]$accion
)

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