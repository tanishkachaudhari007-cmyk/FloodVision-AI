#!/usr/bin/env bash
# FloodVision AI — Linux/macOS Setup Script
# Run from the project root:  bash setup.sh

set -e
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

echo ""
echo "================================================"
echo "  FloodVision AI — Setup Script (Linux / macOS)"
echo "================================================"
echo ""

# ── Prerequisites ─────────────────────────────────────────────────────────────
echo "[1/5] Checking prerequisites..."
command -v node >/dev/null 2>&1 || { echo "ERROR: node not found. Install from https://nodejs.org"; exit 1; }
command -v npm  >/dev/null 2>&1 || { echo "ERROR: npm not found.";  exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "ERROR: python3 not found. Install Python 3.10+"; exit 1; }
echo "  Node.js: $(node --version)"
echo "  npm:     $(npm --version)"
echo "  Python:  $(python3 --version)"

# ── Frontend ──────────────────────────────────────────────────────────────────
echo ""
echo "[2/5] Installing frontend dependencies..."
cd "$ROOT/frontend"
npm install
echo "  Done."

echo ""
echo "[3/5] Building frontend..."
npm run build
echo "  Frontend built to frontend/dist/"

# ── Backend ───────────────────────────────────────────────────────────────────
echo ""
echo "[4/5] Setting up Python backend..."
cd "$ROOT/backend"

if [ ! -d "venv" ]; then
    echo "  Creating virtual environment..."
    python3 -m venv venv
fi

echo "  Installing Python dependencies..."
./venv/bin/pip install --upgrade pip --quiet
./venv/bin/pip install -r requirements-minimal.txt --quiet
./venv/bin/pip install "sqlalchemy[asyncio]" greenlet --quiet

if [ ! -f ".env" ]; then
    echo "  Creating .env from .env.example..."
    cp .env.example .env
    echo "  NOTE: Edit backend/.env to add satellite/AI credentials."
fi

echo "  Done."

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "[5/5] Setup complete!"
echo ""
echo "  To start the application:"
echo ""
echo "    Terminal 1 (backend):"
echo "      cd backend"
echo '      ./venv/bin/python -m uvicorn app.main:app --reload --host 127.0.0.1 --port 8000'
echo ""
echo "    Terminal 2 (frontend):"
echo "      cd frontend"
echo "      npm run dev"
echo ""
echo "    Then open: http://localhost:5173"
echo "    API docs:  http://localhost:8000/api/docs"
echo ""
echo "    Click 'Load Demo Event' on the dashboard to explore all features."
echo ""
