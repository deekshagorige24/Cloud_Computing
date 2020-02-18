#!/bin/bash

#check if ".myipaddr" file exists
FILE=".myipaddr"
if [ -f $FILE ]
then 
    echo "IP READ FROM CACHE"	
else
    echo "CALLING API TO QUERY MY IP"
    `curl -s "Accept: application/json" ipinfo.io/json > $FILE`
fi

#Read the JSON object into a bash variable using 'cat' command
IP_INFO=`cat $FILE` 

#Parsing the latitude and longitude using 'jq' function
#Trim for removing the quotes 
latitude=`echo ${IP_INFO} | jq '.loc' | cut -d ',' -f 1 | tr -d "\""`

longitude=`echo ${IP_INFO} | jq '.loc' | cut -d ',' -f 2 | tr -d "\""`

#Passing on the values of latitude and longitude to the "Weatherbit API"
json_output="$(curl -s "https://api.weatherbit.io/v2.0/forecast/daily?lat=$latitude&lon=$longitude&key=fe518c7ac18542eb87c98af729e4d464")"

#Getting the length of the json_output list
len="$(echo ${json_output} | jq '.data' | jq 'length')" 
length=$(expr $len - 1)

echo "Forecast for my lat=$latitude°, lon=$longitude°"

#Iterating through the list by getting low_temp, high_temp, datetime values
#from the list of JSON elements and printing it in the given format.  
for i in $(seq 0 $length);
do
   max_temp=`echo ${json_output} | jq '.data' | jq '.['$i'].max_temp'`
   min_temp=`echo ${json_output} | jq '.data' | jq '.['$i'].min_temp'`
   date=`echo ${json_output} | jq '.data' | jq '.['$i'].datetime' | tr -d "\""`
   echo "Forecast for $date HI: $max_temp°c LOW: $min_temp°c"
done

