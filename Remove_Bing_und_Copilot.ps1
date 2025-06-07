# 🔍 Bing Websuche im Startmenü deaktivieren
New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -Type DWord -Value 1

# Alternativ (wirkt teils zuverlässiger bei neuen Builds):
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -Type DWord -Value 1

# 🤖 Windows Copilot deaktivieren (ab Build 23493+)
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -Type DWord -Value 1

# Neustart der Explorer Shell oder kompletter Neustart nötig
Write-Host "`n✅ Bing-Suche & Copilot wurden deaktiviert. Bitte neu starten." -ForegroundColor Green
