# recommender-system

A recommendation system project using the MovieLens dataset.

## Prerequisites

- Python 3.12+
- [UV](https://docs.astral.sh/uv/) package manager
- [Docker](https://www.docker.com/) and Docker Compose

### Installing Docker

**macOS:**

Download and install [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/).

**Windows:**

Download and install [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/).

**Linux (Ubuntu/Debian):**

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

Log out and back in for group changes to take effect.

### Installing UV

**macOS / Linux:**

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Windows (PowerShell):**

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**Homebrew (macOS/Linux):**

```bash
brew install uv
```

## Setup

1. Clone the repository:

   ```bash
   git clone git@github.com:matadcze/recommender-system.git
   cd recommender-system
   ```

2. Install dependencies:

   ```bash
   uv sync
   ```

3. Start infrastructure services:

   ```bash
   docker-compose up -d
   ```

   This starts:
   - **PostgreSQL** on port 5432
   - **Spark Master** UI on http://localhost:8080
   - **Spark Worker** connected to master
   - **API (FastAPI)** on http://localhost:8000
   - **Web (Next.js)** on http://localhost:3000

4. Stop services when done:
   ```bash
   docker-compose down
   ```

## Running the Project

Run the main application:

```bash
uv run python main.py
```

## API

The API uses FastAPI. Access the interactive documentation at http://localhost:8000/docs when the containers are running.

Run locally without Docker:

```bash
uv run uvicorn api.main:app --reload
```

## Web Application

The web application uses Next.js. The web container will automatically install dependencies and start the dev server when you run `docker-compose up`.

## Running Notebooks

Start JupyterLab:

```bash
uv run jupyter lab
```

This opens JupyterLab in your browser. Navigate to the `notebooks/` directory and open any notebook.

### Available Notebooks

- `notebooks/01_dataset_exploration.ipynb` - Initial data exploration with MovieLens ratings data. **Note:** To download data via the Kaggle API in this notebook, you must generate an API key (`kaggle.json`) from your Kaggle account settings and store it locally at `~/.kaggle/kaggle.json` (Linux/Mac) or `C:\Users\<username>\.kaggle\kaggle.json` (Windows).
