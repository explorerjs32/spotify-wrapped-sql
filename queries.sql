/*
Author: Francisco Mendez
Date:
Purpose: Create my Spotify Wrapped 2026.
*/

/*
=============================================================================================
INSERT DATA INTO TABLES FROM CSV FILES
=============================================================================================
*/
-- Insert the data into the respective tables
-- .import --csv --skip 1 ./artists.csv artists
-- .import --csv --skip 1 ./tracks.csv tracks
-- .import --csv --skip 1 ./streams.csv streams


/*
=============================================================================================
WRITE THE QUERIES
=============================================================================================
*/
-- How many total minutes did I stream music in 2026?
SELECT
    -- Calculate the total listening time in minutes
    (SUM(stream_time_ms) / 1000) / 60 AS total_stream_minutes
FROM
    streams
;


-- What are the top 10 songs I streamed in 2026 and the top 10 I skipped?
SELECT
    t.name AS Song,
    a.name AS Artist,
    (SUM(stream_time_ms) / 1000) / 60 AS total_stream_minutes
FROM
    streams AS s
    -- Join the streams table with the tracks table
    JOIN
        tracks AS t
    ON
        s.track_id = t.id
    -- Join the streams table with the artists table
    JOIN
        artists AS a
    ON
        s.artist_id = a.id
-- Group the results by track ID to get the total streaming time for each song
GROUP BY
    t.id
-- Order the results by total streaming time in descending order and limit to the top 10 songs
ORDER BY
    total_stream_minutes DESC
LIMIT 10
;

SELECT
    t.name AS Song,
    a.name AS Artist,
    COUNT(s.skipped) AS "Total Skips"
FROM
    streams AS s
    -- Join the streams table with the tracks table
    JOIN
        tracks AS t
    ON
        s.track_id = t.id
    -- Join the streams table with the artists table
    JOIN
        artists AS a
    ON
        s.artist_id = a.id
WHERE
    s.skipped = 'True'
-- Group the results by the track ID to get the total skips for each song
GROUP BY
    t.id
-- Order the results by total skips in descending order and limit to the top 10 songs
ORDER BY
    "Total Skips" DESC
LIMIT 10
;


-- What are the top 10 artists I streamed in 2026 and top 10 I skipped?
SELECT
    a.name AS Artist,
    (SUM(stream_time_ms) / 1000) / 60 AS total_stream_minutes
FROM
    streams AS s
    -- Join the streams table with the artists table on artist ID
    JOIN
        artists AS a
    ON
        s.artist_id = a.id
GROUP BY
    a.id
ORDER BY
    total_stream_minutes DESC
LIMIT 10
;

SELECT
    a.name AS Artist,
    COUNT(s.skipped) AS "Total Skips"
FROM
    streams AS s
    -- Join the streams table with the artists table on artist ID
    JOIN
        artists AS a
    ON
        s.artist_id = a.id
WHERE
    s.skipped = 'True'
GROUP BY
    a.id
ORDER BY
    "Total Skips" DESC
LIMIT 10
;


-- What is my total streaming time by month?
SELECT
    CASE strftime('%m', s.time_stamp)
        WHEN '01' THEN 'January'
        WHEN '02' THEN 'February'
        WHEN '03' THEN 'March'
        WHEN '04' THEN 'April'
        WHEN '05' THEN 'May'
        WHEN '06' THEN 'June'
        WHEN '07' THEN 'July'
        WHEN '08' THEN 'August'
        WHEN '09' THEN 'September'
    END AS Month,
    (SUM(stream_time_ms) / 1000) / 60 AS total_stream_minutes
FROM
    streams AS s
GROUP BY
    Month
ORDER BY
    strftime('%m', s.time_stamp)
;

-- What are the top 10 days I stremed the most and my daily average?
WITH daily_streams AS (
    SELECT
        strftime('%Y-%m-%d', time_stamp) AS Day,
        (SUM(stream_time_ms) / 1000) / 60 AS total_stream_minutes
    FROM
        streams
    GROUP BY
        Day
)

SELECT
    Day,
    total_stream_minutes
FROM
    daily_streams
ORDER BY
    total_stream_minutes DESC
LIMIT 10
;

-- Alternatively, use the daily_streaming_time View to get the top 10 days I streamed the most and my daily average
SELECT
    Day,
    total_stream_minutes
FROM
    daily_streaming_time
ORDER BY
    total_stream_minutes DESC
LIMIT 10
;

-- Daily Average
SELECT
    ROUND(AVG(total_stream_minutes), 0) AS daily_average_minutes
FROM (
    SELECT
        strftime('%Y-%m-%d', time_stamp) AS Day,
        (SUM(stream_time_ms) / 1000) / 60 AS total_stream_minutes
    FROM
        streams
    GROUP BY
        Day
    )
;