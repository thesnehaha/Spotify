# Spotify SQL EDA Project

This project involves performing Exploratory Data Analysis (EDA) on a Spotify dataset using PostgreSQL and pgAdmin. The dataset contains various audio and streaming features for tracks, including artist information, album types, song characteristics (danceability, energy, tempo, etc.), and engagement metrics such as views, likes, comments, and streams.

Through this analysis, I have also derived insights relevant to business analysis, including patterns in user engagement, platform-specific performance, and streaming behavior across different content types.

## Dataset Description

- **Source**: [Kaggle - Spotify Dataset by Sanjana Chaudhari](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)
- **File Used**: `spotify_dataset.csv`
- **Total Records**: ~1,100+
  

## Table Schema

```sql
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
