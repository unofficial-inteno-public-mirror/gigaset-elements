#!/bin/sh

LED=$1
SCENARIO=$2

if [ "$LED" == "cloud" ]; then
    case "$SCENARIO" in
        on)
            ubus call led.status set '{"state":"ok"}'
            ;;

        off|error)
            ubus call led.status set '{"state":"error"}'
            ;;

        slow)
            ubus call led.status set '{"state":"notice"}'
            ;;

        fast)
            ubus call led.status set '{"state":"alert"}'
            ;;

        *)
            exit 1
            ;;
    esac
    exit 0
fi


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

