# Windows Clean Install Setup + Debloat Script
# ============================================
# Dieses PowerShell-Skript entfernt unnötige Apps, deaktiviert Datensammlung
# und verbessert die Performance direkt nach einer frischen Windows-Installation.
# Es ist für Windows 10 und 11 geeignet und zielt darauf ab, ein sauberes,
# funktionales, aber optimiertes System bereitzustellen.
#
# Anwendungsfall: Nach Installation von Windows mit Rufus vorbereiten,
# dieses Skript als Admin ausführen.

# --------------------
# 1. Bloatware entfernen
# --------------------
$appsToRemove = @(
  "Microsoft.3DBuilder",
  "Microsoft.BingNews",
  "Microsoft.GetHelp",
  "Microsoft.Getstarted",
  "Microsoft.Microsoft3DViewer",
  "Microsoft.MicrosoftOfficeHub",
  "Microsoft.MicrosoftSolitaireCollection",
  "Microsoft.MicrosoftStickyNotes",
  "Microsoft.MixedReality.Portal",
  "Microsoft.OneConnect",
  "Microsoft.People",
  "Microsoft.Print3D",
  "Microsoft.SkypeApp",
  "Microsoft.Todos",
  "Microsoft.Wallet",
  "Microsoft.Xbox.TCUI",
  "Microsoft.XboxGameOverlay",
  "Microsoft.XboxGamingOverlay",
  "Microsoft.XboxIdentityProvider",
  "Microsoft.XboxSpeechToTextOverlay",
  "Microsoft.XboxApp",
  "Microsoft.GamingApp",  
  "Microsoft.XboxLive",
  "Microsoft.ZuneMusic",
  "Microsoft.ZuneVideo"
)

foreach ($app in $appsToRemove) {
    Write-Output "Entferne $app ..."
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -EQ $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

# --------------------
# 2. Optional: OneDrive entfernen
# --------------------
Start-Process -FilePath "cmd.exe" -ArgumentList "/c %SystemRoot%\System32\OneDriveSetup.exe /uninstall" -Wait

# --------------------
# 3. Cortana entfernen
# --------------------
If (Get-AppxPackage -Name "Microsoft.549981C3F5F10" -AllUsers) {
    Get-AppxPackage -Name "Microsoft.549981C3F5F10" -AllUsers | Remove-AppxPackage
}

# --------------------
# 4. Hintergrund-Apps deaktivieren
# --------------------
Get-AppxPackage | ForEach-Object {
    $manifest = "$($_.InstallLocation)\AppxManifest.xml"
    if (Test-Path $manifest) {
        Add-AppxPackage -DisableDevelopmentMode -Register $manifest -ForceApplicationShutdown
    }
}

# --------------------
# 5. Nicht-kritische Dienste deaktivieren
# --------------------
$servicesToDisable = @(
  "DiagTrack",
  "dmwappushservice",
  "RetailDemo",
  "XblAuthManager",
  "XblGameSave",
  "XboxNetApiSvc"
)

foreach ($svc in $servicesToDisable) {
    if (Get-Service -Name $svc -ErrorAction SilentlyContinue) {
        Stop-Service -Name $svc -Force
        Set-Service -Name $svc -StartupType Disabled
        Write-Output "Deaktiviert Dienst: $svc"
    }
}

# --------------------
# 6. Geplante Aufgaben deaktivieren
# --------------------
Get-ScheduledTask | Where-Object {
    $_.TaskName -like "*Telemetry*" -or $_.TaskName -like "*Customer Experience*"
} | Disable-ScheduledTask

# --------------------
# 7. Datenschutzanpassungen
# --------------------
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0

# Windows Update: Benachrichtigen vor Download (Option 2)
New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Value 2

# Zusätzlich sicherstellen, dass Windows Update aktiviert bleibt:
Set-Service -Name wuauserv -StartupType Automatic

# Zurücksetzen auf Standardverhalten (automatische Updates):
# Remove-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" -Recurse -Force

Write-Output "✅ Windows wurde erfolgreich optimiert und bereinigt. Neustart empfohlen."

# --------------------
# Hinweis:
# Defender, Updates, Treiber, Microsoft Store bleiben aktiv.
# Dieses Skript ist sicher für Alltagsnutzung & Gaming.

