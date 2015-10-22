#!/bin/sh



# Return device version
#
get_version()
{
    local dev_info=$(cat /lib/db/version/iop_version)

    echo ${dev_info}
}



# unlock basestation
export system_locked="false"

# disable jbus log
export jbus_logcfg="0"

# read device id
DEVICE_ID=$(uci get gigaset.elements.deviceid 2> /dev/null)
export DEVICE_ID="$DEVICE_ID"

# git tag/hash
export BAS_TAG="bas-001.000.038"
export BAS_HASH="3837546f98d4aca60a6e269d2bac790942e498b2"

# user agent
export UA="Basestation/${BAS_TAG}/$(get_version)"

# SUOTA TFTP directory
export TFTP_DIR=/usr/gigaset/data/fw/sensors



# check if DEVICE_ID is set
if [ -z "$DEVICE_ID" ]; then
    printf "DEVICE_ID not set. Aborted" > /dev/console
    exit 1
fi

