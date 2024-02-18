CREATE OR REPLACE EXTERNAL TABLE `ny_taxi.fhv_taxi_tripdata_hw`
OPTIONS (
  format = 'CSV',
  uris = ['gs://mage-zoom-data-bucket/fhv_taxi_data_2019/*.csv']
);

select count(1) from ny_taxi.fhv_taxi_tripdata_hw -- 43,244,696

select * from ny_taxi.fhv_taxi_tripdata_hw limit 1

select distinct SR_Flag from ny_taxi.fhv_taxi_tripdata_hw limit 1

select * from `dbt_zoompcamp_ds123.stg_fhv_tripdata` limit 10;

select count(1) from `dbt_zoompcamp_ds123.stg_fhv_tripdata`; -- 43,244,696

-- Fact creation query
select fhv_tripdata.dispatching_base_num, 
    fhv_tripdata.pickup_locationid, 
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone, 
    fhv_tripdata.dropoff_locationid,
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone,  
    fhv_tripdata.pickup_datetime, 
    fhv_tripdata.dropoff_datetime, 
    fhv_tripdata.sr_flag, 
    fhv_tripdata.affiliated_base_num
from dbt_zoompcamp_ds123.stg_fhv_tripdata as fhv_tripdata
inner join dbt_zoompcamp_ds123.dim_zones as pickup_zone
on fhv_tripdata.pickup_locationid = pickup_zone.locationid
inner join dbt_zoompcamp_ds123.dim_zones as dropoff_zone
on fhv_tripdata.dropoff_locationid = dropoff_zone.locationid;

-- data in fact table
select * from dbt_zoompcamp_ds123.fact_fhv_trips limit 100;

select count(1) from dbt_zoompcamp_ds123.fact_fhv_trips; -- 22,998,722

select * from dbt_zoompcamp_ds123.fct_trips limit 10;

-- July Trips (Green and Yellow)
select service_type, count(1) as total_rides from dbt_zoompcamp_ds123.fct_trips
where EXTRACT(YEAR FROM pickup_datetime) = 2019 and EXTRACT(MONTH FROM pickup_datetime) = 7
group by service_type

Yellow 3248701
Green 415373

-- July Trips (FHV)
select count(1) as total_rides from dbt_zoompcamp_ds123.fact_fhv_trips
where EXTRACT(YEAR FROM pickup_datetime) = 2019 and EXTRACT(MONTH FROM pickup_datetime) = 7 -- 290680

