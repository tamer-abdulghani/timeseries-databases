#!/usr/bin/env bash

load_mmsi_list(){
    rm -rf mmsi.txt
    ./crate/crash --command "SELECT DISTINCT MMSI FROM AIS" >> mmsi.txt
}

load_data_by_mmsi(){
    mmsi=$1
    time1="'04/02/2019 18:00:00'"
    time2="'04/02/2019 21:00:00'"
    db='"ais"'

    command="SELECT * FROM ${db} where timestamp >= ${time1} and timestamp <= ${time2} and mmsi = ${mmsi}"
    ## ./crate/crash --command "${command}" >> result.txt
    http localhost:4200/_sql stmt="${command}" >> result.txt
}

load_mmsi_list

rm -rf result.txt
mmsiList=()
while IFS='' read -r line || [[ -n "$line" ]]; do
    mmsi=`echo "$line" | sed 's/[^0-9]*//g'`
    if [[ ${mmsi} =~ ^-?[0-9]+$ ]]; then
        mmsiList+=( ${mmsi} )
    fi
done < "mmsi.txt"

# HTTPie cannot be used in the same context of other input command ( < "mmsi.txt" XXXX doesn't work)
# ===> we need a separate list and loop it, then call httpie from inside

for i in "${mmsiList[@]}"
do :
   load_data_by_mmsi $i
done