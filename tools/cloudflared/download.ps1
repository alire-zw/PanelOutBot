$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$OutFile = Join-Path $Root "cloudflared.exe"
$Url = "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe"

if (Test-Path $OutFile) {
  Write-Host "cloudflared.exe already exists." -ForegroundColor Yellow
  & $OutFile version
  exit 0
}

Write-Host "Downloading cloudflared..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $Url -OutFile $OutFile
& $OutFile version
Write-Host "Done: $OutFile" -ForegroundColor Green
