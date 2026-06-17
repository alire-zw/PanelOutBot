$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Cloudflared = Join-Path $Root "cloudflared.exe"
$Config = Join-Path $Root "config.yml"
$Credentials = Join-Path $Root "panelout.json"
$TunnelId = "5fe8ff59-7ebe-48c9-b731-fec3fa4a40fb"

if (-not (Test-Path $Cloudflared)) {
  Write-Host "cloudflared.exe not found." -ForegroundColor Red
  exit 1
}

if (-not (Test-Path $Credentials)) {
  Write-Host "Missing panelout.json - run: npm run tunnel:setup" -ForegroundColor Red
  exit 1
}

Write-Host "Tunnel: https://pnlout.mirall.ir -> http://127.0.0.1:4444" -ForegroundColor Cyan
Set-Location $Root
& $Cloudflared tunnel --config $Config --protocol http2 run $TunnelId
