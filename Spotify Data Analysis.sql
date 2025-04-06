-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-------------------------------------------
--EDA
-------------------------------------------

-- Total number of records
SELECT COUNT(*) AS total_records
FROM spotify;

-- Number of unique artists
SELECT COUNT(DISTINCT artist) AS unique_artists
FROM spotify;

-- Number of unique albums
SELECT COUNT(DISTINCT album) AS unique_albums
FROM spotify;

-- Number of unique tracks
SELECT COUNT(DISTINCT track) AS unique_tracks
FROM spotify;


-- Delete songs with zero duration 
SELECT * FROM spotify WHERE duration_min = 0;
DELETE FROM spotify WHERE duration_min = 0;

-- Count NULLs in each column
SELECT
    COUNT(*) FILTER (WHERE artist IS NULL) AS null_artist,
    COUNT(*) FILTER (WHERE track IS NULL) AS null_track,
    COUNT(*) FILTER (WHERE album IS NULL) AS null_album,
    COUNT(*) FILTER (WHERE danceability IS NULL) AS null_danceability,
    COUNT(*) FILTER (WHERE energy IS NULL) AS null_energy,
    COUNT(*) FILTER (WHERE loudness IS NULL) AS null_loudness,
    COUNT(*) FILTER (WHERE speechiness IS NULL) AS null_speechiness,
    COUNT(*) FILTER (WHERE acousticness IS NULL) AS null_acousticness,
    COUNT(*) FILTER (WHERE instrumentalness IS NULL) AS null_instrumentalness,
    COUNT(*) FILTER (WHERE liveness IS NULL) AS null_liveness,
    COUNT(*) FILTER (WHERE valence IS NULL) AS null_valence,
    COUNT(*) FILTER (WHERE tempo IS NULL) AS null_tempo,
    COUNT(*) FILTER (WHERE duration_min IS NULL) AS null_duration,
    COUNT(*) FILTER (WHERE views IS NULL) AS null_views,
    COUNT(*) FILTER (WHERE likes IS NULL) AS null_likes,
    COUNT(*) FILTER (WHERE comments IS NULL) AS null_comments,
    COUNT(*) FILTER (WHERE stream IS NULL) AS null_stream
FROM spotify;

-- Summary statistics for numeric columns
SELECT
    ROUND(AVG(danceability)::numeric, 3) AS avg_danceability,
    ROUND(AVG(energy)::numeric, 3) AS avg_energy,
    ROUND(AVG(loudness)::numeric, 3) AS avg_loudness,
    ROUND(AVG(tempo)::numeric, 3) AS avg_tempo,
    ROUND(AVG(duration_min)::numeric, 3) AS avg_duration,
    MAX(stream) AS max_stream,
    MIN(stream) AS min_stream
FROM spotify;

-- Most common album types
SELECT album_type, COUNT(*) AS count
FROM spotify
GROUP BY album_type
ORDER BY count DESC;

-- Most common genres/platforms (if available)
SELECT most_played_on, COUNT(*) AS count
FROM spotify
GROUP BY most_played_on
ORDER BY count DESC;

-- Tracks grouped by official video status
SELECT official_video, COUNT(*) AS total
FROM spotify
GROUP BY official_video;


--------------------------------------------------
--BUSINESS PROBLEMS
--------------------------------------------------

-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
SELECT track
FROM spotify
WHERE stream > 1000000000;

-- 2. List all albums along with their respective artists.
SELECT DISTINCT album, artist
FROM spotify;

-- 3. Get the total number of comments for tracks where licensed = TRUE.
SELECT SUM(comments) AS total_comments
FROM spotify
WHERE licensed = TRUE;

-- 4. Find all tracks that belong to the album type 'single'.
SELECT track
FROM spotify
WHERE album_type = 'single';

-- 5. Count the total number of tracks by each artist.
SELECT artist, COUNT(*) AS total_tracks
FROM spotify
GROUP BY artist;

-- 6. Calculate the average danceability of tracks in each album.
SELECT album, AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album;

-- 7. Find the top 5 tracks with the highest energy values.
SELECT track, energy
FROM spotify
ORDER BY energy DESC
LIMIT 5;

-- 8. List all tracks along with their views and likes where official_video = TRUE.
SELECT track, views, likes
FROM spotify
WHERE official_video = TRUE;

-- 9. For each album, calculate the total views of all associated tracks.
SELECT album, SUM(views) AS total_views
FROM spotify
GROUP BY album;

-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube views.
SELECT track
FROM spotify
WHERE stream > views;

-- 11. Find the top 3 most-viewed tracks for each artist using window functions.
SELECT artist, track, views
FROM (
    SELECT artist, track, views,
           RANK() OVER (PARTITION BY artist ORDER BY views DESC) AS rank
    FROM spotify
) ranked
WHERE rank <= 3;

-- 12. Write a query to find tracks where the liveness score is above the average.
SELECT track, liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);

-- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH energy_diff AS (
    SELECT album,
           MAX(energy) AS max_energy,
           MIN(energy) AS min_energy
    FROM spotify
    GROUP BY album
)
SELECT album, max_energy, min_energy, (max_energy - min_energy) AS energy_range
FROM energy_diff;
