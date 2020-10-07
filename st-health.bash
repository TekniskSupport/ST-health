#!/bin/bash
. ./secrets
devices=$(curl -XGET \
  -s \
  -H "Authorization: Bearer $token" \
  -H "Content-Type: application/json" \
  "$hassUri/api/states" > hassDevices.json
);

devices=$(smartthings devices -j | jq .[].deviceId | sed "s/\"//g")
for dev in $devices
  do
     offlineDevice=$(smartthings devices:health -j "$dev" | jq '. | select(.state| contains("OFFLINE")) .deviceId'| sed "s/\"//g")
     if [[ ! -z $offlineDevice ]];then
        echo "device offline $offlineDevice"
         device=$(smartthings devices -j "$offlineDevice"| jq .label | sed "s/\"//g")
         entities=$(python3 matchDevice.py "$device")
         for entity in $entities
           do
             echo "marked entity $device - $entity unavailable"
             echo $(curl -XPOST \
              -s \
              -H "Authorization: Bearer $token" \
              -H "Content-Type: application/json" \
              "$hassUri/api/states/$entity" \
              -d '{"state": "unavailable"}' \
             );
         done
     fi
 done

$(rm -f hassDevices.json)
