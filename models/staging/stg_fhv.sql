-- dispatching_base_num  pickup_datetime  dropOff_datetime  PUlocationID  DOlocationID  SR_Flag  Affiliated_base_number

{{ config(materialized='view') }}

with tripdata as
(
  select *,
    row_number() over(partition by base_license, pickup_datetime) as rn
  from {{ source('staging','fhv') }}
  where vendorid is not null
)

select
   -- identifiers
    {{ dbt_utils.surrogate_key(['dispatching_base_num', 'tpep_pickup_datetime']) }} as tripid,
    cast(dispatching_base_num as string) as base_license,
    cast(PUlocationid as integer) as  pickup_locationid,
    cast(DOlocationid as integer) as dropoff_locationid,

    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropOff_datetime as timestamp) as dropoff_datetime,

    -- shared trip
    cast(SR_Flag as integer) as shared_ride_type,
    {{ get_shared_ride_description(sr_flag) }} as shared_ride_description,
    cast(Affiliated_base_number as string) as shared_ride_base_license

from tripdata
where rn = 1

{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}
    