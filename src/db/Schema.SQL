-- Indicators
CREATE TABLE IF NOT EXISTS dim_indicator (
  indicator_code TEXT PRIMARY KEY,
  indicator_name TEXT NOT NULL,
  language TEXT,
  source_url TEXT
);

-- Locations (covers both countries and regions)
CREATE TABLE IF NOT EXISTS dim_location (
  spatial_dim TEXT PRIMARY KEY,       -- code: e.g., 'BRA' or 'AMR'
  location_type TEXT,                 -- e.g., 'COUNTRY','REGION','GLOBAL' (from SpatialDimType)
  region_code TEXT,                   -- e.g., 'AMR'
  region_name TEXT                    -- e.g., 'Americas'
);
CREATE INDEX IF NOT EXISTS idx_location_region ON dim_location(region_code);

-- Time
CREATE TABLE IF NOT EXISTS dim_time (
  year INT PRIMARY KEY,
  start_date DATE,
  end_date DATE
);

-- Sex & Age group (explicit, nullable FKs from fact)
CREATE TABLE IF NOT EXISTS dim_sex (
  sex_code TEXT PRIMARY KEY,          -- e.g., 'SEX_FMLE'
  sex_label TEXT                      -- e.g., 'Female'
);

CREATE TABLE IF NOT EXISTS dim_agegroup (
  agegroup_code TEXT PRIMARY KEY,     -- e.g., 'AGEGROUP_YEARS15-24'
  agegroup_label TEXT                 -- e.g., '15–24 years'
);

-- Observations
-- Table without the expression UNIQUE
CREATE TABLE IF NOT EXISTS fact_gho_observation (
  id BIGINT PRIMARY KEY,
  indicator_code TEXT NOT NULL REFERENCES dim_indicator(indicator_code),
  spatial_dim TEXT NOT NULL REFERENCES dim_location(spatial_dim),
  time_year INT NOT NULL REFERENCES dim_time(year),

  sex_code TEXT NULL REFERENCES dim_sex(sex_code),
  agegroup_code TEXT NULL REFERENCES dim_agegroup(agegroup_code),

  value_raw TEXT,
  numeric_value DOUBLE PRECISION,
  low DOUBLE PRECISION,
  high DOUBLE PRECISION,
  comments TEXT,

  data_source_dim_type TEXT,
  data_source_dim TEXT,
  api_record_date TIMESTAMPTZ,
  time_dim_type TEXT,
  time_dimension_value TEXT,
  time_begin TIMESTAMPTZ,
  time_end TIMESTAMPTZ
);

-- NULL-safe natural-key guard (allowed because indexes can use expressions) 
CREATE UNIQUE INDEX IF NOT EXISTS uq_fact_obs_natkey
ON fact_gho_observation
(
  indicator_code,
  spatial_dim,
  time_year,
  COALESCE(sex_code, ''),
  COALESCE(agegroup_code, '')
);

-- Before the unique index, it was:
--   UNIQUE (indicator_code, spatial_dim, time_year, COALESCE(sex_code,''), COALESCE(agegroup_code,''))
-- );

-- contraints like unique cannot include expressions like coalesce
-- but indexes can 
-- enforces uniqueness across the natural key while treating NULLs as empty strings so duplicates don’t sneak in when Sex/Age are missing