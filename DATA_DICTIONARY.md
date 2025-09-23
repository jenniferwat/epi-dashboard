## Data Dictionary

This document describes the fields, data types, and meaning of each column in the fact table, as they are stored in Postgres.

| **Field** | **Type** | **Description** | **Example** | **Allowed Values** |
|----------|----------|----------------|-------------|-------------------|
| `id` | Integer | Unique identifier for each record | `29571` | Any positive integer |
| `indicator_code` | String | The indicator the measurement is for | `TB_c_newinc` | Any code from the indicator dimension table primary key |
| `spatial_dim` | String | The country the measurement is for | `IRL` | Any code from the location dimension table, spatial_dim primary key|
| `time_year` | Date | Year the measurement is for | `2019` | Any year in the range 1990-2023 |
| `sex_code` | String | The sex of individuals included in the measurement if present, blank if non-sex-specific| `SEX_FMLE`| `SEX_FMLE`  or `SEX_MLE` |
| `agegroup_code` | String | The age range of individuals included in the measurement if present, blank if non-age-specific| `AGEGROUP_YEARS05-09`|Any age group code from the primary key of the agegroup dimension table |
| `value_raw` | String | The value summary returned by the OData API with value and lower and upper limits| `998 000 [768 000 - 1 260 000]` | Numbers and numerical ranges as a text|
| `numeric_value` | Float | Only the main numeric measurement from the 'value' data | `998 000` | Must be ≥ 0 |
| `low` | Float | Only the lower bound of the measurement range from the 'value' data | `768 000` | Must be ≥ 0 |
| `high` | Float | Only the upper bound of the measurement range from the 'value' data | `1 260 000` | Must be ≥ 0 |
| `comments` | String |Any comments about the measurement from the WHO| | Any text or null|
| `data_source_dim_type` | String |The type of data source if different to WHO GHO| | Any text or null|
| `data_source_dim` | String |The data source if different to WHO GHO| | Any text or null|
| `api_record_date` | Datetime (DD/MM/YYYY HH:MM:SS)| Timestamp when the record was created | `11/06/2013 13:01:25` | Any valid date/time in this format |
| `time_dim_type` | String | Type of a second time dimension for the measurement if needed | `YEAR` | Any text|
| `time_dimension_value` | String | Value of a second time dimension for the measurement if needed | `2008` | Any text|
| `time_begin` | Datetime (DD/MM/YYYY HH:MM:SS) | Lower limit of time_dimension_value | `31/12/2007 23:00:00` | Any valid date/time in this format|
| `time_end` | Datetime (DD/MM/YYYY HH:MM:SS) | Upper limit of time_dimension_value| `30/12/2008 23:00:00` | Any valid date/time in this format |

<!-- 
| `status` | Enum | Current state of the record | `active` | `active`, `inactive`, `pending` |
 -->