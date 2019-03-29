#!/usr/bin/env bash

load_mmsi_list(){
    rm -rf mmsi.txt
    docker exec -it my-imply ./bin/dsql --execute 'SELECT DISTINCT mmsi FROM "aisp1-20190204"' >> mmsi.txt
}

load_data_by_mmsi(){
    mmsi=$1
    time1="'2019-02-04 18:00:00'"
    time2="'2019-02-04 21:00:00'"
    db='"aisp1-20190204"'

    command="SELECT * FROM ${db} where __time >= Timestamp ${time1} and __time <= Timestamp ${time2} and mmsi = ${mmsi}"
    docker exec my-imply ./bin/dsql --execute "${command}" >> result.txt
}

load_mmsi_list

rm -rf result.txt

while IFS='' read -r line || [[ -n "$line" ]]; do
    mmsi=`echo "$line" | sed 's/[^0-9]*//g'`
    if [[ ${mmsi} =~ ^-?[0-9]+$ ]]; then
        load_data_by_mmsi ${mmsi}
    fi
done < "mmsi.txt"
