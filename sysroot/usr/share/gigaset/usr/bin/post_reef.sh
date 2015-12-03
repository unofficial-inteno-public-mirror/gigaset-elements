#!/bin/sh


# Return status of wan interface
#
get_wan_status()
{
    local dev=$(uci get network.wan.ifname)
    status=$(ifconfig $dev 2>/dev/null)

    [[ -n "$status" ]] && echo "up"
}



sleep 1

# Send network status
if [[ "$(get_wan_status)" == "up" ]]; then
    touch /var/run/lan.ok
    echo -e "{\"link\": true}" | /usr/bin/sender 127.0.0.1 network
else
    echo -e "{\"link\": false}" | /usr/bin/sender 127.0.0.1 network
fi

