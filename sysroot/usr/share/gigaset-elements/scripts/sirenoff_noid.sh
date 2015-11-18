#!/bin/sh

SIRENS_AVAILABLE=$(show_sensors.sh | grep 'is01' | cut -d: -f1 | cut -d\" -f2)

if [ -z "$SIRENS_AVAILABLE" ]; then
    exit 1
fi

for SIREN in $SIRENS_AVAILABLE
do
    sirenoff.sh $SIREN
done

