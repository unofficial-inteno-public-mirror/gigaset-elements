#!/bin/sh

LED=$1
SCENARIO=$2

if [ "$LED" == "dect" ]; then
    case "$SCENARIO" in
        off)
            ubus call led.dect set '{"state":"off"}'
            ;;

        slow)
            ubus call led.dect set '{"state":"notice"}'
            ;;
        *)
            exit 1
            ;;
    esac
    exit 0
fi

