#!/bin/sh

LED=$1
SCENARIO=$2

if [ "$LED" == "dect" ]; then
    case "$SCENARIO" in
        off)
            # With the introduction of Dectmngr2 in Iopsys LED
            # behavior has changed:
            #   off = radio disabled
            #   on = radio enabled
            #   flashing = registration active
            ubus call led.dect set '{"state":"on"}'
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

