-- 1. movie.csv
CREATE TABLE movies (
    movie_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    genres TEXT
);

-- 2. link.csv
CREATE TABLE links (
    movie_id INTEGER PRIMARY KEY REFERENCES movies(movie_id),
    imdb_id INTEGER,
    tmdb_id INTEGER
);

-- 3. rating.csv
CREATE TABLE ratings (
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL REFERENCES movies(movie_id),
    rating REAL NOT NULL,
    rating_timestamp TIMESTAMP,
    PRIMARY KEY (movie_id, user_id)
);

-- 4. tag.csv
CREATE TABLE tags (
    user_id INTEGER NOT NULL,
    movie_id INTEGER REFERENCES movies(movie_id),
    tag TEXT,
    tag_timestamp TIMESTAMP
);

-- 5. genome_tags.csv
CREATE TABLE genome_tags (
    tag_id INTEGER PRIMARY KEY,
    tag TEXT
);

-- 6. genome_scores.csv
CREATE TABLE genome_scores (
    tag_id INTEGER NOT NULL REFERENCES genome_tags(tag_id),
    movie_id INTEGER NOT NULL REFERENCES movies(movie_id),
    relevance REAL,
    PRIMARY KEY (movie_id, tag_id)
);