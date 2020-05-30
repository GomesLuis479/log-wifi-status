#!/bin/bash

current_date_time="`date "+%Y-%m-%d %H:%M:%S"`";
ssid=$(iwgetid -r)

if [ -z "$ssid" ]; 
    then
        echo "${current_date_time} | not connected to wifi network" >> errorLog.txt
    else
        ping -W 1 -c 1  8.8.8.8 > tempPingOutput.txt

        # process packets received
        receivedString=$(grep -oP  '\d+ received' tempPingOutput.txt)
        receivedStringArraySplit=( $receivedString )
        packetsReceived="${receivedStringArraySplit[0]}"

        # process response time
        grep -oP  'time=\d+' tempPingOutput.txt > tempResTime.txt
        responseTime=$(grep -oP  '\d+' tempResTime.txt)

        if [ "$packetsReceived" -eq "0" ]; 
            then
                echo "${current_date_time} | ${ssid}  | failed to reach server" >> errorLog.txt
            else
                echo "${current_date_time} | ${ssid}  | reached server with ping ${responseTime} ms" >> networkLog.txt
        fi
fi



