#!/bin/bash
devices=$(smartthings devices -j | jq .[].deviceId | sed "s/\"//g")
for dev in $devices
  do 
     offlineDevice=$(smartthings devices:health -j "$dev" | jq '. | select(.state| contains("OFFLINE")) .deviceId'| sed "s/\"//g")
     if [[ ! -z $offlineDevice ]];then
	 echo "device offline {$offlineDevice}"
         smartthings devices -j "$offlineDevice"| jq .label | sed "s/\"//g"
     fi
 done
