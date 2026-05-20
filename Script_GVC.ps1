# ============================================================
# Correção SonicWall GVC + Wi-Fi lento
# SonicWall GVC Fix + Slow Wi-Fi Fix
# Desativa RSC e recursos relacionados no adaptador Wi-Fi
# Disables RSC and related resources on the Wi-Fi adapter
# ============================================================

param(
    [string]$AdapterName = "Wi-Fi"
)

# Verifica se está rodando como Administrador
# Check if running as Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERRO: Este script requer privilégios de Administrador." -ForegroundColor Red
    Write-Host "ERROR: This script requires Administrator privileges." -ForegroundColor Red
    Write-Host "Execute o PowerShell como Administrador e tente novamente." -ForegroundColor Red
    Write-Host "Run PowerShell as Administrator and try again." -ForegroundColor Red
    exit 1
}

Write-Host "============================================================"
Write-Host " Verificando adaptador: $AdapterName"
Write-Host " Checking adapter: $AdapterName"
Write-Host "============================================================"

$adapter = Get-NetAdapter -Name $AdapterName -ErrorAction SilentlyContinue

if (-not $adapter) {
    Write-Host "ERRO: Adaptador '$AdapterName' não encontrado."
    Write-Host "ERROR: Adapter '$AdapterName' not found."
    Write-Host "Adaptadores disponíveis:"
    Write-Host "Available adapters:"
    Get-NetAdapter | Format-Table Name, InterfaceDescription, Status, LinkSpeed -AutoSize
    exit 1
}

Write-Host "`nAdaptador encontrado:"
Write-Host "`nAdapter found:"
$adapter | Format-Table Name, InterfaceDescription, Status, LinkSpeed -AutoSize


Write-Host "`n============================================================"
Write-Host " STATUS RSC ANTES"
Write-Host " RSC STATUS BEFORE"
Write-Host "============================================================"

$rscBefore = Get-NetAdapterRsc -Name $AdapterName -ErrorAction SilentlyContinue
$rscBefore | Format-Table Name, IPv4Enabled, IPv6Enabled, IPv4OperationalState, IPv6OperationalState -AutoSize


Write-Host "`n============================================================"
Write-Host " DESATIVANDO RSC"
Write-Host " DISABLING RSC"
Write-Host "============================================================"

try {
    Disable-NetAdapterRsc -Name $AdapterName -ErrorAction Stop
    Write-Host "RSC desativado com sucesso no adaptador $AdapterName."
    Write-Host "RSC successfully disabled on adapter $AdapterName."
} catch {
    Write-Host "Falha ao desativar RSC via Disable-NetAdapterRsc."
    Write-Host "Failed to disable RSC via Disable-NetAdapterRsc."
    Write-Host "Erro: $($_.Exception.Message)"
    Write-Host "Error: $($_.Exception.Message)"
}


Write-Host "`n============================================================"
Write-Host " STATUS RSC DEPOIS"
Write-Host " RSC STATUS AFTER"
Write-Host "============================================================"

$rscAfter = Get-NetAdapterRsc -Name $AdapterName -ErrorAction SilentlyContinue
if ($rscAfter) {
    $rscAfter | Format-Table Name, IPv4Enabled, IPv6Enabled, IPv4OperationalState, IPv6OperationalState -AutoSize
} else {
    Write-Host "Aviso: Não foi possível obter o status RSC do adaptador." -ForegroundColor Yellow
    Write-Host "Warning: Unable to retrieve RSC status for the adapter." -ForegroundColor Yellow
}

if ($rscAfter -and $rscAfter.IPv4Enabled -eq $false -and $rscAfter.IPv6Enabled -eq $false) {
    Write-Host "`nOK: RSC ficou desativado em IPv4 e IPv6."
    Write-Host "`nOK: RSC is disabled on IPv4 and IPv6."
} else {
    Write-Host "`nATENÇÃO: RSC ainda aparece como ativo. Aplicando ajustes complementares..."
    Write-Host "`nWARNING: RSC still appears active. Applying additional adjustments..."

    $AdvancedPropsToDisable = @(
        "Large Send Offload v2 (IPv4)",
        "Large Send Offload v2 (IPv6)",
        "TCP Checksum Offload (IPv4)",
        "TCP Checksum Offload (IPv6)",
        "UDP Checksum Offload (IPv4)",
        "UDP Checksum Offload (IPv6)",
        "Packet Coalescing"
    )

    foreach ($prop in $AdvancedPropsToDisable) {
        try {
            Set-NetAdapterAdvancedProperty `
                -Name $AdapterName `
                -DisplayName $prop `
                -DisplayValue "Disabled" `
                -NoRestart `
                -ErrorAction Stop

            Write-Host "Desativado: $prop"
            Write-Host "Disabled: $prop"
        } catch {
            Write-Host "Não encontrado ou não aplicável: $prop"
            Write-Host "Not found or not applicable: $prop"
        }
    }

    # Ajustes de energia/estabilidade comuns em Wi-Fi
    # Common power/stability adjustments for Wi-Fi
    $AdvancedPropsCustom = @(
        @{ Name = "MIMO Power Save Mode"; Value = "No SMPS" },
        @{ Name = "Preferred Band"; Value = "Prefer 5GHz" },
        @{ Name = "Roaming Aggressiveness"; Value = "Lowest" },
        @{ Name = "Transmit Power"; Value = "Highest" }
    )

    foreach ($item in $AdvancedPropsCustom) {
        try {
            Set-NetAdapterAdvancedProperty `
                -Name $AdapterName `
                -DisplayName $item.Name `
                -DisplayValue $item.Value `
                -NoRestart `
                -ErrorAction Stop

            Write-Host "Ajustado: $($item.Name) => $($item.Value)"
            Write-Host "Adjusted: $($item.Name) => $($item.Value)"
        } catch {
            Write-Host "Não encontrado ou valor não aceito: $($item.Name)"
            Write-Host "Not found or value not accepted: $($item.Name)"
        }
    }

    Write-Host "`nReiniciando adaptador Wi-Fi..."
    Write-Host "`nRestarting Wi-Fi adapter..."
    Restart-NetAdapter -Name $AdapterName -Confirm:$false
    Start-Sleep -Seconds 5
}


Write-Host "`n============================================================"
Write-Host " STATUS FINAL DO RSC"
Write-Host " FINAL RSC STATUS"
Write-Host "============================================================"

$rscFinal = Get-NetAdapterRsc -Name $AdapterName -ErrorAction SilentlyContinue
if ($rscFinal) {
    $rscFinal | Format-Table Name, IPv4Enabled, IPv6Enabled, IPv4OperationalState, IPv6OperationalState -AutoSize
} else {
    Write-Host "Não foi possível obter o status final do RSC." -ForegroundColor Yellow
    Write-Host "Unable to retrieve final RSC status." -ForegroundColor Yellow
}


Write-Host "`n============================================================"
Write-Host " PROPRIEDADES AVANCADAS DO WI-FI"
Write-Host " ADVANCED WI-FI PROPERTIES"
Write-Host "============================================================"

Get-NetAdapterAdvancedProperty -Name $AdapterName |
    Sort-Object DisplayName |
    Format-Table DisplayName, DisplayValue -AutoSize


Write-Host "`n============================================================"
Write-Host " MTU ATUAL"
Write-Host " CURRENT MTU"
Write-Host "============================================================"

netsh interface ipv4 show subinterface