#!/usr/bin/env pwsh
# FloodVision AI — Windows Setup Script
# Run from the project root:  .\setup.ps1

$ErrorActionPreference = "Stop"
$ROOT = $PSScriptRoot

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  FloodVision AI — Setup Script (Windows / PowerShell)" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# ── Check prerequisites ─────────────────────────────────────────────────────
Write-Host "[1/5] Checking prerequisites..." -ForegroundColor Yellow

$nodeVer = node --version 2>$null
if (-not $nodeVer) { Write-Error "Node.js not found. Install from https://nodejs.org" }
Write-Host "  Node.js: $nodeVer" -ForegroundColor Green

$npmVer = npm --version 2>$null
Write-Host "  npm:     $npmVer" -ForegroundColor Green

$pyVer = python --version 2>$null
if (-not $pyVer) { Write-Error "Python not found. Install from https://python.org" }
Write-Host "  Python:  $pyVer" -ForegroundColor Green

# ── Frontend ─────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "[2/5] Installing frontend dependencies..." -ForegroundColor Yellow
Push-Location "$ROOT\frontend"
npm install
Write-Host "  Frontend dependencies installed." -ForegroundColor Green
Pop-Location

# ── Frontend build ───────────────────────────────────────────────────────────
Write-Host ""
Write-Host "[3/5] Building frontend (TypeScript + Vite)..." -ForegroundColor Yellow
Push-Location "$ROOT\frontend"
npm run build
Write-Host "  Frontend built to frontend/dist/" -ForegroundColor Green
Pop-Location

# ── Backend virtual environment ──────────────────────────────────────────────
Write-Host ""
Write-Host "[4/5] Setting up Python backend..." -ForegroundColor Yellow
Push-Location "$ROOT\backend"

if (-not (Test-Path "venv")) {
    Write-Host "  Creating virtual environment..." -ForegroundColor Gray
    python -m venv venv
}

Write-Host "  Installing Python dependencies (minimal set)..." -ForegroundColor Gray
& ".\venv\Scripts\pip.exe" install --upgrade pip --quiet
& ".\venv\Scripts\pip.exe" install -r requirements-minimal.txt --quiet

# Install greenlet for SQLAlchemy async
& ".\venv\Scripts\pip.exe" install "sqlalchemy[asyncio]" greenlet --quiet

Write-Host "  Backend dependencies installed." -ForegroundColor Green

# ── Environment file ──────────────────────────────────────────────────────────
if (-not (Test-Path ".env")) {
    Write-Host "  Creating .env from .env.example..." -ForegroundColor Gray
    Copy-Item ".env.example" ".env"
    Write-Host "  .env created. Edit backend\.env to add satellite/AI credentials." -ForegroundColor Yellow
}

Pop-Location

# ── Summary ───────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "[5/5] Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "  To start the application:" -ForegroundColor Cyan
Write-Host ""
Write-Host "    Terminal 1 (backend):"
Write-Host "      cd backend"
Write-Host "      .\venv\Scripts\python.exe -m uvicorn app.main:app --reload --host 127.0.0.1 --port 8000"
Write-Host ""
Write-Host "    Terminal 2 (frontend):"
Write-Host "      cd frontend"
Write-Host "      npm run dev"
Write-Host ""
Write-Host "    Then open: http://localhost:5173"
Write-Host "    API docs:  http://localhost:8000/api/docs"
Write-Host ""
Write-Host "    Click 'Load Demo Event' on the dashboard to explore all features." -ForegroundColor Cyan
Write-Host ""
