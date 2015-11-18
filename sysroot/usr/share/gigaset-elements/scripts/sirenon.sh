#!/bin/sh
if [ -z "$1" ]; then 
              echo usage: $0 sensorId
              exit 1
fi

echo \{\"cmd\":\"sirenon\",\"devId\":\"$1\"\} > /var/sirenon.json
sender 127.0.0.1 ulecontrol /var/sirenon.json


