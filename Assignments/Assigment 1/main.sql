CREATE TABLE stations AS
WITH raw AS (
    SELECT UNNEST(features) AS feature
    FROM read_json_auto('Assignments/Assigment 1/stations.json')
)
SELECT
    feature.properties.name AS name,
    feature.properties.code AS code,
    feature.properties.state AS state,
    feature.properties.zone AS zone,
    feature.properties.address AS address,
    feature.geometry.coordinates[1] AS longitude,
    feature.geometry.coordinates[2] AS latitude
FROM raw;

-- 1. TOP-3 states by number of stations in each zone
WITH station_counts AS (
    SELECT
        zone,
        state,
        COUNT(*) AS station_count,
        RANK() OVER (PARTITION BY zone ORDER BY COUNT(*) DESC) AS rank,
        SUM(COUNT(*)) OVER (PARTITION BY zone) AS zone_total
    FROM stations
    WHERE state IS NOT NULL AND zone IS NOT NULL AND zone != '?'
    GROUP BY zone, state
)
SELECT zone, state, station_count, rank
FROM station_counts
WHERE rank <= 3
ORDER BY zone_total DESC, rank;

--2. Comparing quantity of stations in each state with average in every zone
WITH zone_avg AS (
    SELECT
        zone,
        state,
        COUNT(*) AS station_count,
        ROUND(AVG(COUNT(*)) OVER (PARTITION BY zone), 2) AS avg_per_zone
    FROM stations
    WHERE state IS NOT NULL AND zone IS NOT NULL AND zone != '?'
    GROUP BY zone, state
)
SELECT
    zone,
    state,
    station_count,
    avg_per_zone AS avg_per_zone,
    station_count - avg_per_zone AS difference
FROM zone_avg
ORDER BY difference;