# apps_optional.ps1 – Installiert zusätzliche Tools per winget
# Bitte als Administrator ausführen

Write-Host "🟢 Starte Installation deiner optionalen Tools..." -ForegroundColor Green

# Liste ausgewählter Programme
$tools = @(
    @{ Name = "7-Zip";             ID = "7zip.7zip" },
    @{ Name = "Everything";        ID = "voidtools.Everything" },
    @{ Name = "PowerToys";         ID = "Microsoft.PowerToys" },
    @{ Name = "Git";               ID = "Git.Git" },
    @{ Name = "VLC Media Player";  ID = "VideoLAN.VLC" }
)

foreach ($tool in $tools) {
    Write-Host "📦 Installiere $($tool.Name) ..." -ForegroundColor Cyan
    winget install --id=$($tool.ID) -e --accept-source-agreements --accept-package-agreements
}

Write-Host "`n✅ Alle Tools wurden installiert!" -ForegroundColor Green
