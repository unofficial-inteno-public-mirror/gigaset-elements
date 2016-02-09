#!/bin/sh


# Copied from /sbin/testnet
#
test_connection() {
    local defroute="$(ip r | grep default | awk '{print$3}')"
    local def6route="$(ip -f inet6 r | grep default | awk '{print$3}')"
    local ping6dev="$(ip -f inet6 r | grep default | awk '{print$5}')"

    if [ -n "$defroute" ]; then
        ping -q -w 5 -c 1 $defroute >/dev/null 2>&1 && return 0
        for nmsrv in $(grep nameserver /var/resolv.conf.auto | awk '{print$2}'); do
            ping -q -w 5 -c 1 $nmsrv >/dev/null 2>&1 && return 0
        done
    elif [ -n "$def6route" ] && [ -n "$ping6dev" ]; then
        ndisc6 -w 5 -1 $def6route $ping6dev >/dev/null 2>&1 && return 0
    fi
    return 1
}




sleep 1

# Send network status
if test_connection ; then
    touch /var/run/lan.ok
    echo -e "{\"link\": true}" | /usr/bin/sender 127.0.0.1 network
else
    echo -e "{\"link\": false}" | /usr/bin/sender 127.0.0.1 network
fi

