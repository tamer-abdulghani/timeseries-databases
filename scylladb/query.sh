#!/usr/bin/env bash

# influx -execute 'SELECT * FROM ais_me limit 10' -database="AIS"

load_mmsi_list(){
    rm -rf mmsi.txt
    rm -rf mmsitmp.txt

    docker exec -it my-scylla-db cqlsh -e "SELECT DISTINCT mmsi FROM ais_ks.ais_ts" >> mmsitmp.txt

    while IFS='' read -r line || [[ -n "$line" ]]; do
        mmsi=`echo "$line" | sed 's/[^0-9]*//g'`
        if [[ ${mmsi} =~ ^-?[0-9]+$ ]]; then
            ## Below commands is to remove color format from mmsi id and then store the mmsi in mmsi.txt
            newmmsi=`echo ${mmsi} | cut -c 5-`
            echo `sed 's/.\{1\}$//' <<< "${newmmsi}"` >> mmsi.txt
        fi
    done < "mmsitmp.txt"

    rm -rf mmsitmp.txt
}

load_data_by_mmsi(){
    mmsi=$1
    time1="1549303200"
    time2="1549314000"
    db="ais_ks.ais_ts"

    command="SELECT * FROM ${db} where timestamp >= ${time1} and timestamp <= ${time2} and mmsi = ${mmsi}"
    docker exec my-scylla-db cqlsh -e "${command}" >> result.txt
}

load_mmsi_list

rm -rf result.txt

while IFS='' read -r line || [[ -n "$line" ]]; do
    mmsi=`echo "$line" | sed 's/[^0-9]*//g'`
    if [[ ${mmsi} =~ ^-?[0-9]+$ ]]; then
        load_data_by_mmsi ${mmsi}
    fi
done < "mmsi.txt"
