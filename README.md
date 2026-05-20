# Script_GVC.ps1 - SonicWall GVC + Wi-Fi Slow Fix
# Script_GVC.ps1 - Correção SonicWall GVC + Wi-Fi Lento

## English 🇬🇧

### Description
A PowerShell script designed to fix slow Wi-Fi connection issues, especially those related to SonicWall GVC. The script disables RSC (Receive Side Coalescing) and other network offloading features to improve stability and performance.

### Features
- ✅ Automatic detection and validation of Wi-Fi adapter
- ✅ Disables RSC (Receive Side Coalescing) on IPv4 and IPv6
- ✅ Disables packet offloading and TCP/UDP checksums
- ✅ Optimizes advanced network properties
- ✅ Comprehensive status reports (before and after)
- ✅ Bilingual output (Portuguese/English)
- ✅ Custom adapter support via parameters
- ✅ Error handling and rollback guidance

### Prerequisites
- Windows 10/11 or higher
- PowerShell 3.0 or higher
- **Administrator privileges (required)**
- Active Wi-Fi connection

### Quick Start

1. Open PowerShell **as Administrator**
2. Navigate to the script folder:
   ```powershell
   cd "C:\path\to\script"
   ```
3. Run the script:
   ```powershell
   .\Script_GVC.ps1
   ```

Or with a custom adapter:
```powershell
.\Script_GVC.ps1 -AdapterName "Ethernet"
```

### Usage Guides
- **📖 English Guide**: See [GUIDE_Script_GVC.txt](GUIDE_Script_GVC.txt) for detailed instructions
- **📖 Portuguese Guide**: See [GUIA_Script_GVC.txt](GUIA_Script_GVC.txt) for instruções detalhadas

### Common Issues

| Issue | Solution |
|-------|----------|
| "Adapter not found" | Run without parameters to see available adapters |
| "Failed to disable RSC" | Normal on some adapters; alternative adjustments will apply |
| "Not found or not applicable" | Property doesn't exist on this adapter; safe to ignore |
| "Access denied" | Run PowerShell as Administrator |

### How to Undo Changes
1. Go to: Settings → Network & Internet → Wi-Fi
2. Click "Manage known networks"
3. Right-click on Wi-Fi → Properties
4. Click "Configure"
5. Open the "Advanced" tab
6. Restore default values for properties

### Supported Adapters
- Wi-Fi (default)
- Ethernet
- Any network adapter name

### Output
The script displays:
- Pre-modification RSC status
- Post-modification RSC status
- Applied advanced property changes
- Final network configuration

---

## Português 🇧🇷

### Descrição
Um script PowerShell projetado para corrigir problemas de conexão Wi-Fi lenta, especialmente aqueles relacionados ao SonicWall GVC. O script desativa RSC (Receive Side Coalescing) e outros recursos de offloading de rede para melhorar a estabilidade e o desempenho.

### Funcionalidades
- ✅ Detecção automática e validação do adaptador Wi-Fi
- ✅ Desativa RSC (Receive Side Coalescing) em IPv4 e IPv6
- ✅ Desativa offloading de pacotes e checksums TCP/UDP
- ✅ Otimiza propriedades avançadas de rede
- ✅ Relatórios abrangentes de status (antes e depois)
- ✅ Saída bilíngue (Português/Inglês)
- ✅ Suporte a adaptador customizado via parâmetros
- ✅ Tratamento de erros e orientação de reversão

### Pré-requisitos
- Windows 10/11 ou superior
- PowerShell 3.0 ou superior
- **Privilégios de Administrador (obrigatório)**
- Conexão Wi-Fi ativa

### Início Rápido

1. Abra o PowerShell **como Administrador**
2. Navegue até a pasta do script:
   ```powershell
   cd "C:\caminho\para\script"
   ```
3. Execute o script:
   ```powershell
   .\Script_GVC.ps1
   ```

Ou com um adaptador customizado:
```powershell
.\Script_GVC.ps1 -AdapterName "Ethernet"
```

### Guias de Uso
- **📖 Guia em Português**: Veja [GUIA_Script_GVC.txt](GUIA_Script_GVC.txt) para instruções detalhadas
- **📖 Guia em Inglês**: Veja [GUIDE_Script_GVC.txt](GUIDE_Script_GVC.txt) for detailed instructions

### Problemas Comuns

| Problema | Solução |
|----------|---------|
| "Adaptador não encontrado" | Execute sem parâmetros para ver adaptadores disponíveis |
| "Falha ao desativar RSC" | Normal em alguns adaptadores; ajustes alternativos serão aplicados |
| "Não encontrado ou não aplicável" | Propriedade não existe neste adaptador; seguro ignorar |
| "Acesso negado" | Execute o PowerShell como Administrador |

### Como Desfazer Alterações
1. Acesse: Configurações → Rede e Internet → Wi-Fi
2. Clique em "Gerenciar redes conhecidas"
3. Clique com botão direito em Wi-Fi → Propriedades
4. Clique em "Configurar"
5. Abra a aba "Avançado"
6. Restaure os valores padrão das propriedades

### Adaptadores Suportados
- Wi-Fi (padrão)
- Ethernet
- Qualquer nome de adaptador de rede

### Saída do Script
O script exibe:
- Status RSC antes das modificações
- Status RSC após modificações
- Mudanças de propriedades avançadas aplicadas
- Configuração final da rede

---

## Technical Details / Detalhes Técnicos

### What the Script Does / O que o Script Faz

1. **RSC Disabling** / **Desativação de RSC**
   - Disables Receive Side Coalescing on both IPv4 and IPv6
   - Reduces latency and improves packet handling

2. **Offload Optimization** / **Otimização de Offload**
   - Disables Large Send Offload v2
   - Disables TCP/UDP Checksum Offload
   - Disables Packet Coalescing

3. **Advanced Property Tuning** / **Ajuste de Propriedades Avançadas**
   - MIMO Power Save Mode: No SMPS
   - Preferred Band: Prefer 5GHz
   - Roaming Aggressiveness: Lowest
   - Transmit Power: Highest

4. **Validation & Reporting** / **Validação e Relatório**
   - Displays pre/post-modification status
   - Automatic fallback to alternative methods
   - Shows final MTU configuration

---

## System Requirements / Requisitos do Sistema

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| OS | Windows 10 | Windows 11 |
| PowerShell | 3.0 | 5.1+ |
| Privileges | Administrator | Administrator |
| Network | Active Wi-Fi | 2.4GHz/5GHz Dual |

---

## Troubleshooting / Solução de Problemas

### Script won't run / Script não executa
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
.\Script_GVC.ps1
```

### No changes detected / Sem mudanças detectadas
- Some adapters may not support all properties
- Try rebooting after script execution
- Check if adapter firmware is up to date

---

## License / Licença
This script is provided as-is for troubleshooting network connectivity issues related to SonicWall GVC.
Este script é fornecido como está para solucionar problemas de conectividade de rede relacionados ao SonicWall GVC.

## Author / Autor
Created by **Danilo Carvalho**  
E-mail: dcarvalho@yessecurity.com.br

---

## Version History / Histórico de Versões

| Version | Date | Changes |
|---------|------|---------|
| 2.0 | May 2026 | Bilingual support, enhanced validation, improved error handling |
| 1.0 | Previous | Initial release |

---

## Disclaimer / Aviso Legal

**Use at your own risk.** This script modifies network adapter settings. It is recommended to:
- ✅ Test in a non-production environment first
- ✅ Backup current settings
- ✅ Understand the changes being made
- ✅ Have administrator privileges
- ✅ Follow the undo instructions if needed

**Use por sua conta e risco.** Este script modifica as configurações do adaptador de rede. Recomenda-se:
- ✅ Testar em um ambiente que não seja de produção primeiro
- ✅ Fazer backup das configurações atuais
- ✅ Entender as mudanças sendo feitas
- ✅ Ter privilégios de administrador
- ✅ Seguir as instruções de desfazer se necessário

---

## Contributing / Contribuindo
Found an issue? Have a suggestion? Please report it or submit a pull request.  
Encontrou um problema? Tem uma sugestão? Por favor reporte ou envie um pull request.

---

**Last Updated**: May 20, 2026  
**Última Atualização**: 20 de Maio de 2026
