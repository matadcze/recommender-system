CREATE SCHEMA IF NOT EXISTS movielens;

SET search_path TO movielens;

-- 1. movie.csv
CREATE TABLE IF NOT EXISTS movies (
    movie_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    genres TEXT
);

-- 2. link.csv
CREATE TABLE IF NOT EXISTS links (
    movie_id INTEGER PRIMARY KEY REFERENCES movies(movie_id),
    imdb_id INTEGER,
    tmdb_id INTEGER
);

-- 3. rating.csv
CREATE TABLE IF NOT EXISTS ratings (
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL REFERENCES movies(movie_id),
    rating REAL NOT NULL,
    rating_timestamp TIMESTAMP,
    PRIMARY KEY (movie_id, user_id)
);

-- 4. tag.csv
CREATE TABLE IF NOT EXISTS tags (
    user_id INTEGER NOT NULL,
    movie_id INTEGER REFERENCES movies(movie_id),
    tag TEXT,
    tag_timestamp TIMESTAMP
);

-- 5. genome_tags.csv
CREATE TABLE IF NOT EXISTS genome_tags (
    tag_id INTEGER PRIMARY KEY,
    tag TEXT
);

-- 6. genome_scores.csv
CREATE TABLE IF NOT EXISTS genome_scores (
    tag_id INTEGER NOT NULL REFERENCES genome_tags(tag_id),
    movie_id INTEGER NOT NULL REFERENCES movies(movie_id),
    relevance REAL,
    PRIMARY KEY (movie_id, tag_id)
);

-- admin access
GRANT USAGE ON SCHEMA movielens TO recommender;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA movielens TO recommender;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA movielens TO recommender;

-- user and access for the app
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'app_user') THEN
        CREATE ROLE app_user WITH LOGIN PASSWORD 'appuser';
    END IF;
END $$;

GRANT USAGE ON SCHEMA movielens TO app_user;
GRANT SELECT ON ALL TABLES IN SCHEMA movielens TO app_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA movielens GRANT SELECT ON TABLES TO app_user;