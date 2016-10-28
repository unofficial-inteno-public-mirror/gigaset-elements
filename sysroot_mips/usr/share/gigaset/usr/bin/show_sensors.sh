#!/bin/sh

if [ -f /usr/gigaset/data/endnodes ]; then
	cat /usr/gigaset/data/endnodes
else
	echo "Endnodes database is empty!"
fi
