#!/bin/sh

GIGA_DIR=${GIGA_DIR:-/usr/share/gigaset}
DATA_DIR=${DATA_DIR:-/usr/gigaset/data}



# Return device version
#
get_version()
{
    local dev_info=$(db get hw.board.iopVersion 2>/dev/null)
    echo ${dev_info}
}


# lock basestation
export system_locked="true"

# disable jbus log
export jbus_logcfg="0"


[[ -z "$TFTP_DIR" ]] && TFTP_DIR=$DATA_DIR/fw/sensors

[[ -z "$DEVICE_ID" ]] && DEVICE_ID=$(uci get gigaset.elements.deviceid 2> /dev/null)

[[ -z "$BAS_TAG" ]]  && BAS_TAG=$(cat $GIGA_DIR/etc/version | grep -w "REEF_BAS_VERSION" | cut -d \" -f 2)/$(get_version)
[[ -z "$BAS_HASH" ]] && BAS_HASH=$(cat $GIGA_DIR/etc/version | grep -w "REEF_BAS_HASH" | cut -d \" -f 2)


# check if DEVICE_ID is set
if [ -z "$DEVICE_ID" ]; then
    logger -s -t gigaset -p alert "DEVICE_ID not set. Aborted"
    exit 1
fi


RUNBG=${RUNBG:-}
[ -f "$GIGA_DIR/runbg" ] && RUNBG=1

if [ -n "$RUNBG" ]; then
    # Overwrite function to run apps in background

    service_start() {
        app="$1"; shift
        args="$@"
        $app $args &
    }

    service_stop() {
        app=$(basename "$1")
        pid=$(pidof $app)
        [[ -n "$pid" ]] && kill -9 $pid
    }
fi

