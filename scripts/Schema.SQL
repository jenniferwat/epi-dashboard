CREATE TABLE dim_indicator (
    indicator_id TEXT PRIMARY KEY,
    indicator_name TEXT
);

CREATE TABLE dim_country (
    country_code TEXT PRIMARY KEY,
    country_name TEXT,
    region TEXT
);

CREATE TABLE fact_measure (
    id SERIAL PRIMARY KEY,
    indicator_id TEXT REFERENCES dim_indicator(indicator_id),
    country_code TEXT REFERENCES dim_country(country_code),
    year INT,
    value NUMERIC
);
