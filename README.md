============================================================
USAGE GUIDE - Script_GVC.ps1
SonicWall GVC Correction + Slow Wi-Fi Fix
============================================================

WHAT DOES THE SCRIPT DO?
------------------------
This script fixes slow Wi-Fi connection issues, especially those 
related to SonicWall GVC. It:

• Disables RSC (Receive Side Coalescing) on the Wi-Fi adapter
• Disables packet offloading and TCP/UDP checksums
• Adjusts advanced properties for better stability
• Restarts the network adapter to apply changes
• Displays reports before and after modifications


PREREQUISITES
--------------
✓ Windows 10/11 or higher
✓ PowerShell 3.0 or higher
✓ ADMINISTRATOR rights (required!)
✓ Active Wi-Fi connection


HOW TO RUN
----------

1. OPEN PowerShell AS ADMINISTRATOR:
   - Click Start (Windows button)
   - Type "PowerShell"
   - Right-click on "Windows PowerShell"
   - Select "Run as administrator"

2. NAVIGATE TO THE SCRIPT FOLDER:
   cd "C:\Script" (Example)

3. RUN THE SCRIPT:

   Option A - With default adapter (Wi-Fi):
   .\Script_GVC.ps1

   Option B - With custom adapter:
   .\Script_GVC.ps1 -AdapterName "Ethernet"

   Option C - If you get a script execution error:
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
   .\Script_GVC.ps1


POSSIBLE WARNINGS DURING EXECUTION
-----------------------------------
• "ERROR: Adapter 'Wi-Fi' not found"
  → The adapter may have a different name. Run without parameters
     to see the list of available adapters.

• "Failed to disable RSC"
  → Normal on some adapters. The script will apply alternative
     adjustments automatically.

• "Not found or not applicable"
  → Means the property doesn't exist on this adapter.
     It's safe to ignore.


EXPECTED AFTER EXECUTION
-------------------------
✓ RSC disabled on IPv4 and IPv6
✓ Reduced offloading
✓ Adapter restarted
✓ More stable Wi-Fi connection


UNDO CHANGES
------------
If something doesn't work as expected:

1. Go to: Settings → Network & Internet → Wi-Fi
2. Click "Manage known networks"
3. Right-click on Wi-Fi → Properties
4. Click "Configure"
5. Open the "Advanced" tab
6. Restore the default values for the properties


SUPPORT/CONTACT
----------------
If the script doesn't solve the problem:
• Check if your router firmware is updated
• Restart your router and computer
• Test with another Wi-Fi adapter if available
• Contact SonicWall support


============================================================
Created by Danilo Carvalho
E-mail: dcarvalho@yessecurity.com.br

Version: 2.0 | Date: May 2026 | Status: Improved
============================================================
