#!/bin/bash

set -e

CONTAINER="recommender-postgres"
DB_USER="recommender"
DB_NAME="recommender"
DATA_DIR="$(cd "$(dirname "$0")/.." && pwd)/data"  # directory with CSV files

echo "Copying CSV files to container..."
docker cp "$DATA_DIR/movie.csv" "$CONTAINER:/tmp/"
docker cp "$DATA_DIR/link.csv" "$CONTAINER:/tmp/"
docker cp "$DATA_DIR/rating.csv" "$CONTAINER:/tmp/"
docker cp "$DATA_DIR/tag.csv" "$CONTAINER:/tmp/"
docker cp "$DATA_DIR/genome_tags.csv" "$CONTAINER:/tmp/"
docker cp "$DATA_DIR/genome_scores.csv" "$CONTAINER:/tmp/"

echo "Loading data into database..."
docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" <<'EOF'
SET search_path TO movielens;

\copy movies(movie_id, title, genres) FROM '/tmp/movie.csv' WITH CSV HEADER
\copy links(movie_id, imdb_id, tmdb_id) FROM '/tmp/link.csv' WITH CSV HEADER
\copy genome_tags(tag_id, tag) FROM '/tmp/genome_tags.csv' WITH CSV HEADER
\copy ratings(user_id, movie_id, rating, rating_timestamp) FROM '/tmp/rating.csv' WITH CSV HEADER
\copy tags(user_id, movie_id, tag, tag_timestamp) FROM '/tmp/tag.csv' WITH CSV HEADER
\copy genome_scores(movie_id, tag_id, relevance) FROM '/tmp/genome_scores.csv' WITH CSV HEADER
EOF

echo "Done!"