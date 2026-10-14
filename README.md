# FloodVision AI

**See the Flood. Map the Damage. Save Lives.**

FloodVision AI is a satellite-powered flood damage mapping and disaster intelligence platform. It combines SAR remote sensing, geospatial analysis, configurable risk scoring, and an AI assistant to support flood event assessment and response prioritization.

Built as a full-stack hackathon application with a React/TypeScript frontend and Python FastAPI backend.

---

## Screenshots

The application runs a complete demo event (Brahmani Basin, Odisha) out of the box — no satellite credentials required. All demo values are clearly labelled as simulated.

---

## Quick Start (5 minutes)

### Prerequisites

- **Node.js** 18+ and npm 9+
- **Python** 3.10+ and pip

### Option A — Automated setup (Windows)

```powershell
.\setup.ps1
```

### Option B — Manual setup

```bash
# 1. Frontend
cd frontend
npm install
npm run build

# 2. Backend
cd backend
python -m venv venv

# Windows:
.\venv\Scripts\pip install -r requirements-minimal.txt
.\venv\Scripts\pip install "sqlalchemy[asyncio]" greenlet

# Linux/macOS:
./venv/bin/pip install -r requirements-minimal.txt
./venv/bin/pip install "sqlalchemy[asyncio]" greenlet

cp .env.example .env
```

### Start the servers

```bash
# Terminal 1 — Backend
cd backend
.\venv\Scripts\python -m uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
# Linux/macOS: ./venv/bin/python -m uvicorn app.main:app --reload

# Terminal 2 — Frontend
cd frontend
npm run dev
```

Open **http://localhost:5173** in your browser.

Click **"Load Demo Event"** on the dashboard to explore all features immediately.

---

## Features

### Frontend (9 pages)

| Page | Description |
|------|-------------|
| **Dashboard** | Key statistics, flood timeline chart, land cover breakdown |
| **Flood Map** | Interactive Leaflet map with flood polygons, roads, buildings, facilities |
| **Before / After** | Pre/post-event satellite comparison with sensor metadata |
| **Infrastructure Exposure** | Buildings, roads, agricultural land, critical facility table |
| **Risk Assessment** | Weighted multi-factor score with radar chart and factor breakdown |
| **AI Assistant** | Chat interface grounded in analysis data (local + LLM fallback) |
| **Reports** | PDF, CSV, GeoJSON export with download |
| **Data Sources** | API health check, satellite provider status, configuration guide |
| **Settings** | Satellite product, date range, threshold, and dataset configuration |

### Backend (8 API routers)

| Endpoint group | Capability |
|----------------|------------|
| `/api/health` | Server status, DB connectivity, service availability |
| `/api/events` | CRUD for analysis events, demo event loader |
| `/api/analysis` | Flood analysis pipeline, polygon storage |
| `/api/infrastructure` | Spatial exposure intersection |
| `/api/risk` | Weighted risk scoring |
| `/api/assistant` | Grounded AI Q&A (local engine + OpenAI/Anthropic) |
| `/api/reports` | PDF/CSV/GeoJSON generation and download |
| `/api/upload` | Validated GeoJSON file upload |

---

## Demo Mode

The application includes a complete simulated demo event:

- **Event:** Hypothetical Brahmani River Basin flood, Odisha, India
- **Extent:** 312.4 km² across 3 flood zones
- **Infrastructure:** 4,218 buildings, 89.3 km of roads, 5 critical facilities
- **Risk:** Critical (87/100)
- **Data mode label:** `demo` — displayed throughout the UI and in all exports

> **All demo values are simulated and not from real satellite observations.**
> The demo is suitable for exploring features but not for actual emergency response.

---

## Satellite Data (Real Mode)

### Sentinel-1/2 (Copernicus Data Space)

```env
COPERNICUS_CLIENT_ID=your-client-id
COPERNICUS_CLIENT_SECRET=your-client-secret
```

Register at https://dataspace.copernicus.eu (free account required).

### Google Earth Engine (optional)

```env
GEE_SERVICE_ACCOUNT=service-account@project.iam.gserviceaccount.com
GEE_KEY_FILE=/path/to/key.json
```

### AI Assistant (optional — has local fallback)

```env
OPENAI_API_KEY=sk-...
# or
ANTHROPIC_API_KEY=sk-ant-...
```

Without credentials, the deterministic local engine answers questions from stored analysis data.

---

## Environment Variables

Copy `backend/.env.example` to `backend/.env`:

| Variable | Required | Description |
|----------|----------|-------------|
| `APP_SECRET_KEY` | Yes (prod) | Secret key for security headers |
| `DATABASE_URL` | No | SQLite (default) or PostgreSQL |
| `ALLOWED_ORIGINS` | No | CORS origins |
| `COPERNICUS_CLIENT_ID` | No | Sentinel-1/2 data access |
| `COPERNICUS_CLIENT_SECRET` | No | Sentinel-1/2 data access |
| `GEE_SERVICE_ACCOUNT` | No | Google Earth Engine |
| `GEE_KEY_FILE` | No | GEE service account key |
| `OPENAI_API_KEY` | No | AI assistant LLM |
| `ANTHROPIC_API_KEY` | No | AI assistant alternative |

---

## Running Tests

```bash
cd backend
.\venv\Scripts\python -m pytest tests/ -v --asyncio-mode=auto
# Linux/macOS: ./venv/bin/python -m pytest ...
```

**55 tests, all passing** (API endpoints, flood analysis, risk scoring).

---

## Production Build

```bash
cd frontend && npm run build    # Outputs to frontend/dist/
cd backend && uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4
```

Frontend dist can be served from any static host (Vercel, Netlify, S3+CloudFront).
Backend deploys to any Python host (Railway, Render, Heroku, AWS, GCP).

### Docker

```bash
docker-compose up --build
# Frontend: http://localhost:3000
# Backend:  http://localhost:8000/api/docs
```

---

## Deployment Checklist

- [ ] Set `APP_SECRET_KEY` to a random 32+ char string
- [ ] Set `APP_ENV=production` and `DEBUG=false`
- [ ] Set `DATABASE_URL` to production PostgreSQL (or keep SQLite for demos)
- [ ] Set `ALLOWED_ORIGINS` to your production frontend URL
- [ ] Configure satellite credentials if using real data
- [ ] Review `backend/.env.example` — never commit `.env`

---

## Known Limitations and Future Work

### Current limitations

1. **No real satellite retrieval implemented** — the Copernicus OData download client needs full implementation (`app/services/copernicus_client.py`). The pipeline framework is in place.
2. **Shapely/GeoPandas/Rasterio require Python 3.10/3.11** — Python 3.14 (the system version) does not yet have binary wheels for all geospatial libraries. The backend runs on the virtual environment which is compatible; the geospatial pipeline degrades to demo mode without them.
3. **No real OSM Overpass integration** — infrastructure exposure uses demo data; the Overpass API client needs implementation.
4. **PDF uses fpdf2 `ln=` deprecated parameter** — cosmetic warning only, PDFs generate correctly. Will be updated to `new_x=/new_y=` syntax.

### Planned improvements

- Copernicus STAC/OData download client
- GEE JRC flood product integration
- Real OSM Overpass API for infrastructure
- WorldPop population grid integration
- Map AOI drawing tool (Leaflet.draw)
- Map snapshot/export to PNG
- GeoTIFF raster export
- Historical flood event database
- Multi-event comparison view
- Real-time monitoring hooks
- Authentication and multi-user support
- PostgreSQL + PostGIS for production spatial queries

---

## API Documentation

With the backend running: http://localhost:8000/api/docs (Swagger UI)

---

## License

MIT License. See LICENSE file.

Third-party data attributions: see [docs/data-sources.md](docs/data-sources.md).

---

## Credits

Built with Sentinel data from the Copernicus Programme (ESA), OpenStreetMap data, and the open-source geospatial Python ecosystem.
