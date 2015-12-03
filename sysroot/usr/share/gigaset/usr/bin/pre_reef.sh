#!/bin/sh


# check if DEVICE_ID is set
if [ -z "$DEVICE_ID" ]; then
    printf "DEVICE_ID not set. Aborted" > /dev/console
    exit 1
fi

