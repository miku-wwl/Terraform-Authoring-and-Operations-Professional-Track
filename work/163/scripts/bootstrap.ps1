$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Force -Path artifacts | Out-Null
'Session 163 challenge checklist' | Set-Content -Path artifacts/checklist.txt -Encoding utf8
Write-Host 'Created checklist.'
