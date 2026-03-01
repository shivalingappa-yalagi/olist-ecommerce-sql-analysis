/*---------------------------------------------------------
    OLIST E-COMMERCE SQL PROJECT
    File: 07_geolocation_analysis.sql
    Purpose: Analyze locations, zip codes, city/state mapping
----------------------------------------------------------*/

-------------------------------------------------------------
-- Q1: Count unique geolocation entries
-- Purpose: Understand coverage of geographic dataset
-------------------------------------------------------------
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT geolocation_zip_code_prefix) AS unique_zip_codes,
    COUNT(DISTINCT geolocation_city) AS unique_cities,
    COUNT(DISTINCT geolocation_state) AS unique_states
FROM olist_geolocation_dataset;


-------------------------------------------------------------
-- Q2: States with the most geo data points
-- Purpose: Identify which states have the highest number of coordinates
-------------------------------------------------------------
SELECT 
    geolocation_state AS state,
    COUNT(*) AS total_points
FROM olist_geolocation_dataset
GROUP BY geolocation_state
ORDER BY total_points DESC
LIMIT 10;


-------------------------------------------------------------
-- Q3: Cities with the most geo data points
-- Purpose: Determine which cities have the highest location density
-------------------------------------------------------------
SELECT 
    geolocation_city AS city,
    COUNT(*) AS total_points
FROM olist_geolocation_dataset
GROUP BY geolocation_city
ORDER BY total_points DESC
LIMIT 15;


-------------------------------------------------------------
-- Q4: Zip codes with highest number of coordinates
-- Purpose: Some zip prefixes appear many times for different coordinates
-------------------------------------------------------------
SELECT 
    geolocation_zip_code_prefix AS zip_code,
    COUNT(*) AS total_points
FROM olist_geolocation_dataset
GROUP BY geolocation_zip_code_prefix
ORDER BY total_points DESC
LIMIT 15;


-------------------------------------------------------------
-- Q5: Validate if multiple cities share same ZIP prefix
-- Purpose: Check for data duplication or mapping inconsistencies
-------------------------------------------------------------
SELECT 
    geolocation_zip_code_prefix AS zip_code,
    COUNT(DISTINCT geolocation_city) AS city_count
FROM olist_geolocation_dataset
GROUP BY geolocation_zip_code_prefix
HAVING city_count > 1
ORDER BY city_count DESC
LIMIT 20;


-------------------------------------------------------------
-- Q6: Top states by seller concentration
-- Purpose: Where most sellers are located
-------------------------------------------------------------
SELECT
    geolocation_state AS state,
    COUNT(*) AS seller_geo_points
FROM olist_geolocation_dataset g
JOIN olist_sellers_dataset s
    ON g.geolocation_zip_code_prefix = s.seller_zip_code_prefix
GROUP BY state
ORDER BY seller_geo_points DESC
LIMIT 10;


-------------------------------------------------------------
-- Q7: Top states by customer concentration
-- Purpose: Where most customers are located
-------------------------------------------------------------
SELECT
    geolocation_state AS state,
    COUNT(*) AS customer_geo_points
FROM olist_geolocation_dataset g
JOIN olist_customers_dataset c
    ON g.geolocation_zip_code_prefix = c.customer_zip_code_prefix
GROUP BY state
ORDER BY customer_geo_points DESC
LIMIT 10;


-------------------------------------------------------------
-- Q8: Mapping cities to average latitude/longitude
-- Purpose: Create usable coordinate mapping for BI / visualization
-------------------------------------------------------------
SELECT
    geolocation_city AS city,
    ROUND(AVG(geolocation_lat), 6) AS avg_latitude,
    ROUND(AVG(geolocation_lng), 6) AS avg_longitude
FROM olist_geolocation_dataset
GROUP BY geolocation_city
ORDER BY city ASC
LIMIT 20;