
CREATE TABLE AIS
(
                time VARCHAR NOT NULL,
                long_timestamp TIMESTAMP NOT NULL,
                type_of_mobile VARCHAR,
                mmsi VARCHAR NOT NULL,
                latitude DOUBLE NOT NULL,
                longitude DOUBLE NOT NULL,
                navigational_status VARCHAR,
                rot VARCHAR,
                sog VARCHAR,
                cog VARCHAR,
                heading VARCHAR,
                imo VARCHAR,
                callsign VARCHAR,
                name VARCHAR,
                ship_type VARCHAR,
                cargo_type VARCHAR,
                width VARCHAR,
                length VARCHAR,
                type_of_position_fixing_device VARCHAR,
                draught VARCHAR,
                destination VARCHAR,
                eta VARCHAR,
                data_source_type VARCHAR,
                a VARCHAR,
                b VARCHAR,
                c VARCHAR,
                d VARCHAR,
                sequence_id VARCHAR NOT NULL,
                partition SINT64 NOT NULL,
                PRIMARY KEY
                (
                    (mmsi, QUANTUM (long_timestamp,15,'s')),
                    mmsi, timestamp
                )
);