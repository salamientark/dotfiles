#!/bin/bash
# Simple battery indicator for i3blocks

BAT=$(acpi -b | grep -P -o '[0-9]+(?=%)')
STATUS=$(acpi -b | awk '{print $3}' | tr -d ',')

if [ "$STATUS" = "Charging" ]; then
    ICON=""
else
    ICON=""
fi

echo "$ICON $BAT%"
