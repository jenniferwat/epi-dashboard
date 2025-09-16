CREATE TABLE dim_location (
  iso3 text PRIMARY KEY,
  country text NOT NULL,
  who_region text,
  income_grp text
);

CREATE TABLE dim_indicator (
  indicator_code text PRIMARY KEY,
  indicator_name text NOT NULL,
  topic text,
  unit text
);

CREATE TABLE fact_observation (
  indicator_code text REFERENCES dim_indicator(indicator_code),
  iso3 text REFERENCES dim_location(iso3),
  time_begin date NOT NULL,
  time_end date,
  value numeric,
  uncertainty_l numeric,
  uncertainty_u numeric,
  sex text,
  agegroup text,
  dims_json jsonb,
  source text,
  PRIMARY KEY (indicator_code, iso3, time_begin)
);

-- COVID weekly for speed (wide-ish but explicit fields)
CREATE TABLE fact_covid_weekly (
  iso3           text REFERENCES dim_location(iso3),
  year_week      text,  -- e.g., '2023-W15'
  new_cases      integer,
  new_deaths     integer,
  cum_cases      integer,
  cum_deaths     integer,
  who_region     text,
  reported_date  date,
  PRIMARY KEY (iso3, year_week)
);

-- Geometries (Natural Earth)
CREATE TABLE geo_country (
  iso3     text PRIMARY KEY,
  name     text,
  geom     geometry(MULTIPOLYGON, 4326)
);

-- Helpful indexes
CREATE INDEX ON fact_observation (indicator_code, iso3, time_begin);
CREATE INDEX ON fact_covid_weekly (iso3, year_week);
CREATE INDEX ON geo_country USING GIST (geom);