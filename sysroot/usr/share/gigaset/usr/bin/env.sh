#!/bin/sh

DATA_DIR=${DATA_DIR:-/usr/gigaset/data}



# Return device version
#
get_version()
{
    local dev_info=$(db get hw.board.iopVersion 2>/dev/null)
    echo ${dev_info}
}


# unlock basestation
export system_locked="false"

# disable jbus log
export jbus_logcfg="0"


[[ -z "$TFTP_DIR" ]] && TFTP_DIR=$DATA_DIR/fw/sensors

[[ -z "$DEVICE_ID" ]] && DEVICE_ID=$(uci get gigaset.elements.deviceid 2> /dev/null)

[[ -z "$BAS_TAG" ]]  && BAS_TAG="bas-001.000.038/$(get_version)"
[[ -z "$BAS_HASH" ]] && BAS_HASH="3837546f98d4aca60a6e269d2bac790942e498b2"





RUNBG=${RUNBG:-}
[ -f "/usr/share/gigaset/runbg" ] && RUNBG=1

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

