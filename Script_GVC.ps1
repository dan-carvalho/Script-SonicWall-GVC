# ============================================================
# Correção SonicWall GVC + Wi-Fi lento
# Desativa RSC e recursos relacionados no adaptador Wi-Fi
# ============================================================

param(
    [string]$AdapterName = "Wi-Fi"
)

# Verifica se está rodando como Administrador
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERRO: Este script requer privilégios de Administrador." -ForegroundColor Red
    Write-Host "Execute o PowerShell como Administrador e tente novamente." -ForegroundColor Red
    exit 1
}

Write-Host "============================================================"
Write-Host " Verificando adaptador: $AdapterName"
Write-Host "============================================================"

$adapter = Get-NetAdapter -Name $AdapterName -ErrorAction SilentlyContinue

if (-not $adapter) {
    Write-Host "ERRO: Adaptador '$AdapterName' não encontrado."
    Write-Host "Adaptadores disponíveis:"
    Get-NetAdapter | Format-Table Name, InterfaceDescription, Status, LinkSpeed -AutoSize
    exit 1
}

Write-Host "`nAdaptador encontrado:"
$adapter | Format-Table Name, InterfaceDescription, Status, LinkSpeed -AutoSize


Write-Host "`n============================================================"
Write-Host " STATUS RSC ANTES"
Write-Host "============================================================"

$rscBefore = Get-NetAdapterRsc -Name $AdapterName -ErrorAction SilentlyContinue
$rscBefore | Format-Table Name, IPv4Enabled, IPv6Enabled, IPv4OperationalState, IPv6OperationalState -AutoSize


Write-Host "`n============================================================"
Write-Host " DESATIVANDO RSC"
Write-Host "============================================================"

try {
    Disable-NetAdapterRsc -Name $AdapterName -ErrorAction Stop
    Write-Host "RSC desativado com sucesso no adaptador $AdapterName."
} catch {
    Write-Host "Falha ao desativar RSC via Disable-NetAdapterRsc."
    Write-Host "Erro: $($_.Exception.Message)"
}


Write-Host "`n============================================================"
Write-Host " STATUS RSC DEPOIS"
Write-Host "============================================================"

$rscAfter = Get-NetAdapterRsc -Name $AdapterName -ErrorAction SilentlyContinue
if ($rscAfter) {
    $rscAfter | Format-Table Name, IPv4Enabled, IPv6Enabled, IPv4OperationalState, IPv6OperationalState -AutoSize
} else {
    Write-Host "Aviso: Não foi possível obter o status RSC do adaptador." -ForegroundColor Yellow
}

if ($rscAfter -and $rscAfter.IPv4Enabled -eq $false -and $rscAfter.IPv6Enabled -eq $false) {
    Write-Host "`nOK: RSC ficou desativado em IPv4 e IPv6."
} else {
    Write-Host "`nATENÇÃO: RSC ainda aparece como ativo. Aplicando ajustes complementares..."

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
                -DisplayValue "Desabilitado" `
                -NoRestart `
                -ErrorAction Stop

            Write-Host "Desativado: $prop"
        } catch {
            Write-Host "Não encontrado ou não aplicável: $prop"
        }
    }

    # Ajustes de energia/estabilidade comuns em Wi-Fi
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
        } catch {
            Write-Host "Não encontrado ou valor não aceito: $($item.Name)"
        }
    }

    Write-Host "`nReiniciando adaptador Wi-Fi..."
    Restart-NetAdapter -Name $AdapterName -Confirm:$false
    Start-Sleep -Seconds 5
}


Write-Host "`n============================================================"
Write-Host " STATUS FINAL DO RSC"
Write-Host "============================================================"

Get-NetAdapterRsc -Name $AdapterName | Format-Table Name, IPv4Enabled, IPv6Enabled, IPv4OperationalState, IPv6OperationalState -AutoSize


Write-Host "`n============================================================"
Write-Host " PROPRIEDADES AVANCADAS DO WI-FI"
Write-Host "============================================================"

Get-NetAdapterAdvancedProperty -Name $AdapterName |
    Sort-Object DisplayName |
    Format-Table DisplayName, DisplayValue -AutoSize


Write-Host "`n============================================================"
Write-Host " MTU ATUAL"
Write-Host "============================================================"

netsh interface ipv4 show subinterface