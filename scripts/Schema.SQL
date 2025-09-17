-- keep all in public
SET search_path TO public;

CREATE TABLE IF NOT EXISTS dim_indicator (
    indicator_id   TEXT PRIMARY KEY,
    indicator_name TEXT
);

CREATE TABLE IF NOT EXISTS dim_country (
    country_code TEXT PRIMARY KEY,
    country_name TEXT,
    region       TEXT
);

CREATE TABLE IF NOT EXISTS fact_measure (
    id           BIGSERIAL PRIMARY KEY,
    indicator_id TEXT NOT NULL REFERENCES dim_indicator(indicator_id),
    country_code TEXT NOT NULL REFERENCES dim_country(country_code),
    year         INT,
    value        NUMERIC,
    CONSTRAINT uq_fact UNIQUE (indicator_id, country_code, year)
);

-- simple run log for observability
CREATE TABLE IF NOT EXISTS etl_run_log (
    run_id      BIGSERIAL PRIMARY KEY,
    started_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    finished_at TIMESTAMPTZ,
    status      TEXT,           -- 'success' | 'failed'
    details     TEXT
);

-- helpful indexes for PBI slicers/joins
CREATE INDEX IF NOT EXISTS idx_fact_indicator  ON fact_measure (indicator_id);
CREATE INDEX IF NOT EXISTS idx_fact_country    ON fact_measure (country_code);
CREATE INDEX IF NOT EXISTS idx_fact_year       ON fact_measure (year);

