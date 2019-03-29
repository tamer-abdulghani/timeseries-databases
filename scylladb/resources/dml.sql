
-- create keyspace

CREATE KEYSPACE IF NOT EXISTS ais_ks WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };

-- create table with partition key: mmsi && secondary key: sequence_id
CREATE TABLE ais_ks.ais_ts2
(
   timestamp timestamp,
   type_of_mobile text,
   mmsi text,
   latitude float,
   longitude float,
   navigational_status text,
   rot text,
   sog text,
   cog text,
   heading text,
   imo text,
   callsign text,
   name text,
   ship_type text,
   cargo_type text,
   width text,
   length text,
   type_of_position_fixing_device text,
   draught text,
   destination text,
   eta text,
   data_source_type text,
   a text,
   b text,
   c text,
   d text,
   long_timestamp timestamp,
   sequence_id text,
   partition int,
   PRIMARY KEY (mmsi, timestamp)
);

-- show table schema
describe table ais_ks.ais_ts