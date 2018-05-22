#!/bin/bash
source ~/.bashrc

table_name=$1

hql="show partitions ${table_name}"

beeline2 --silent=true --delimiterForDSV="|" --showHeader=false --incremental=true --outputformat=dsv -e "${hql}" \
| grep "\=2017" | awk -F"/" '{print $1}' | sort -u > rm_$table_name.txt

for PTS in `cat rm_$table_name.txt`;
do 
    beeline2 --silent=true --delimiterForDSV="|" --showHeader=false --incremental=true --outputformat=dsv -e \
    "alter table ${table_name} drop if exists partition(${PTS})"
    echo "rm partition ${PTS}"
done






