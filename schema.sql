/*
Author: Francisco Mendez
Date:
Purpose: create a database schema for the CS50SQL Final Project.
*/

/*
=============================================================================================
CREATE TABLES
=============================================================================================
*/
-- Create the artists table
CREATE TABLE artists (
    "id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Create the tracks table
CREATE TABLE tracks (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "album" TEXT NOT NULL,
    "artist" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Create the streams table
CREATE TABLE streams (
    "track_id" TEXT NOT NULL,
    "artist_id" INTEGER NOT NULL,
    "stream_time_ms" INTEGER NOT NULL DEFAULT 0,
    "time_stamp" NUMERIC NOT NULL,
    "skipped" TEXT NOT NULL CHECK("skipped" IN ('True','False')),
    FOREIGN KEY("track_id") REFERENCES tracks("id"),
    FOREIGN KEY("artist_id") REFERENCES artists("id")
);


/*
=============================================================================================
CREATE INDEXES
=============================================================================================
*/
-- Index the foreign key columns in the streams table for faster lookups
CREATE INDEX "stream_track_index" ON "streams"("track_id");
CREATE INDEX "stream_artist_index" ON "streams"("artist_id");

-- Index the skipped column in the streams table for faster filtering
CREATE INDEX "stream_skipped_index" ON "streams"("skipped");


/*
=============================================================================================
CREATE VIEWS
=============================================================================================
*/
-- Create a View to calculate the daily streaming time in minutes for each day in 2026
CREATE VIEW "daily_streaming_time" AS
SELECT
    strftime('%Y-%m-%d', time_stamp) AS Day,
    (SUM(stream_time_ms) / 1000) / 60 AS total_stream_minutes
FROM
    streams
GROUP BY
    Day;