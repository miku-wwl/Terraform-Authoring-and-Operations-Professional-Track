$ErrorActionPreference = 'Stop'
if (-not (Test-Path artifacts\checklist.txt)) { throw 'missing checklist' }
Write-Host 'PASS: checklist exists.'
