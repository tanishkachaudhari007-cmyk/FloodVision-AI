#!/usr/bin/env pwsh
# FloodVision AI — Start both servers for local development
# Opens two new terminal windows.
# Run from the project root:  .\start-dev.ps1

$ROOT = $PSScriptRoot

Write-Host "Starting FloodVision AI development servers..." -ForegroundColor Cyan
Write-Host ""

# Backend
Write-Host "Starting backend on http://127.0.0.1:8000 ..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "
  Set-Location '$ROOT\backend';
  Write-Host 'FloodVision AI — Backend' -ForegroundColor Cyan;
  .\venv\Scripts\python.exe -m uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
"

Start-Sleep -Seconds 2

# Frontend
Write-Host "Starting frontend on http://localhost:5173 ..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "
  Set-Location '$ROOT\frontend';
  Write-Host 'FloodVision AI — Frontend' -ForegroundColor Cyan;
  npm run dev
"

Write-Host ""
Write-Host "Servers starting. Open http://localhost:5173 in your browser." -ForegroundColor Green
Write-Host "API docs available at http://localhost:8000/api/docs" -ForegroundColor Green
