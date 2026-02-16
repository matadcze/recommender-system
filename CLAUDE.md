# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A recommendation system project using the MovieLens 20M dataset. The primary focus is learning Apache Spark and the Hadoop ecosystem through Jupyter notebooks, with a supporting FastAPI backend and Next.js frontend.

## Commands

```bash
# Install dependencies
uv sync

# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# Start Jupyter Lab (runs locally, connects to Docker Spark)
uv run jupyter lab

# Run API locally
uv run uvicorn api.main:app --reload

# Web dev server (runs inside Docker)
# Access at http://localhost:3000
```

## Architecture

All services run via Docker Compose. The Jupyter container connects to Spark master and PostgreSQL using Docker networking (container hostnames, not localhost).

**Services and ports:**

- **PostgreSQL**: port 5432, creds `recommender`/`recommender`, db `recommender`
- **Spark Master**: UI http://localhost:8080, master `spark://spark-master:7077`
- **Spark Worker**: 8GB memory, 4 cores
- **Jupyter**: http://localhost:8888 (no token)
- **API**: http://localhost:8000 (FastAPI, docs at /docs)
- **Web**: http://localhost:3000 (Next.js 16 + React 19 + Tailwind 4)

## Database Schema

PostgreSQL schema `movielens` with tables: `movies`, `ratings`, `tags`, `links`, `genome_tags`, `genome_scores`. Schema initialized from `db/schema.sql`. There's also an `app_user` role (password `appuser`) with read-only access.

## Spark Connection Pattern

All notebooks use this pattern to connect to the Docker Spark cluster:

```python
spark = SparkSession.builder \
    .appName("...") \
    .master("spark://spark-master:7077") \
    .config("spark.jars.packages", "org.postgresql:postgresql:42.7.1") \
    .config("spark.driver.memory", "6g") \
    .config("spark.executor.memory", "7g") \
    .config("spark.driver.host", "recommender-jupyter") \
    .config("spark.driver.bindAddress", "0.0.0.0") \
    .getOrCreate()

jdbc_url = "jdbc:postgresql://postgres:5432/recommender"
jdbc_props = {"user": "recommender", "password": "recommender", "driver": "org.postgresql.Driver"}
```

Key: hostnames (`spark-master`, `postgres`, `recommender-jupyter`) are Docker container names, not localhost.

## Notebooks

Notebooks are numbered sequentially and cover a learning progression:

- **01-03**: Basics (dataset exploration with pandas, ALS model training, PostgreSQL)
- **04-08**: Core Spark (DataFrame ops, SQL, aggregations, partitioning, MLlib ALS deep dive)
- **09-14**: Advanced Spark (streaming, GraphFrames, advanced MLlib, performance internals, ETL/Delta Lake, integration projects)
- **15+**: Hadoop ecosystem (HDFS, HBase, Trino, Flink, NiFi, Atlas, Ranger, Zeppelin)

All notebook explanations are written in Polish. When creating new notebooks, follow the existing style: markdown headers with Polish descriptions, code cells with working examples, exercises at end of sections.

## Project Structure

```
recommender-system/
├── api/              # FastAPI backend (api/main.py)
├── db/schema.sql     # PostgreSQL schema initialization
├── notebooks/        # Jupyter notebooks (numbered learning sequence)
├── web/              # Next.js frontend
├── Dockerfile.spark  # Spark image (Python 3.12 + UV on Apache Spark 4.1.1)
├── Dockerfile.postgres
├── docker-compose.yml
├── pyproject.toml    # UV project config
└── main.py           # Entry point (placeholder)
```

## Data

The `data/` directory is gitignored. MovieLens data lives at `data/raw/movielens/`. Data is loaded into PostgreSQL's `movielens` schema and accessed via Spark JDBC or pandas/SQLAlchemy.
