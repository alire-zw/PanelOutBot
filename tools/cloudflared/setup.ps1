$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Cloudflared = Join-Path $Root "cloudflared.exe"
$Credentials = Join-Path $Root "panelout.json"
$Hostname = "pnlout.mirall.ir"
$TunnelName = "panelout"
$TunnelId = "5fe8ff59-7ebe-48c9-b731-fec3fa4a40fb"
$CertFile = Join-Path $env:USERPROFILE ".cloudflared\cert.pem"

if (-not (Test-Path $Cloudflared)) {
  Write-Host "cloudflared.exe not found. Run download.ps1 first." -ForegroundColor Red
  exit 1
}

if (-not (Test-Path $CertFile)) {
  Write-Host "1/3 Login to Cloudflare (browser opens)..." -ForegroundColor Cyan
  & $Cloudflared tunnel login
} else {
  Write-Host "1/3 Cloudflare login skipped (already logged in)." -ForegroundColor Yellow
}

Write-Host "2/3 Check tunnel credentials..." -ForegroundColor Cyan
if (-not (Test-Path $Credentials)) {
  Write-Host "   creating tunnel '$TunnelName'..." -ForegroundColor Cyan
  & $Cloudflared tunnel --credentials-file $Credentials create $TunnelName
} else {
  Write-Host "   credentials OK: panelout.json" -ForegroundColor Green
}

Write-Host "3/3 Route DNS $Hostname..." -ForegroundColor Cyan
$route = & $Cloudflared tunnel route dns $TunnelName $Hostname 2>&1
if ($LASTEXITCODE -ne 0 -and $route -match "already exists") {
  Write-Host "   DNS record exists - update manually in Cloudflare:" -ForegroundColor Yellow
  Write-Host "   CNAME pnlout -> $TunnelId.cfargotunnel.com" -ForegroundColor Yellow
} else {
  Write-Host "   $route" -ForegroundColor Green
}

Write-Host ""
Write-Host "Done. WEBHOOK_URL=https://$Hostname" -ForegroundColor Green
Write-Host "1) npm run dev" -ForegroundColor Cyan
Write-Host "2) npm run tunnel" -ForegroundColor Cyan
