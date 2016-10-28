#!/bin/sh

echo "WDT RESET - $(date)" > /dev/console

# hide pid of current wdt instance
# it will stop by itself afterwards
rm -f /var/run/wdt.pid

/etc/init.d/gigaset-elements restart

