#!/usr/bin/env bash

# influx -execute 'SELECT * FROM ais_me limit 10' -database="AIS"

load_mmsi_list(){
    rm -rf mmsi.txt
    docker exec -it my-influxdb influx -execute 'SELECT DISTINCT("mmsi") FROM (SELECT "longitude","mmsi" FROM ais_ms)' -database="ais_db" >> mmsi.txt
}

load_data_by_mmsi(){
    mmsi=$1
    time1="'2019-02-04T18:00:00Z'"
    time2="'2019-02-04T21:00:00Z'"
    db='"ais_db"'
    ms='"ais_ms"'

    command="SELECT * FROM ${ms} where time >= ${time1} and time <= ${time2} and mmsi = '${mmsi}'"
    docker exec my-influxdb influx -execute "${command}" -database="ais_db" >> result.txt
}

load_mmsi_list

rm -rf result.txt

while IFS='' read -r line || [[ -n "$line" ]]; do
    mmsi=`echo "$line" | sed 's/[^0-9]*//g'`
    if [[ ${mmsi} =~ ^-?[0-9]+$ ]]; then
        load_data_by_mmsi ${mmsi:1}
    fi
done < "mmsi.txt"
