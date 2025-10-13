#!/bin/bash

# The output to control (e.g., eDP, eDP-1, LVDS1). Find yours with `xrandr`.
OUTPUT="eDP-1"

# The amount to increase/decrease brightness by
STEP=0.05

# Get the current brightness
CURRENT=$(xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' ')

# Handle the script argument
case $1 in
  up)
    # Calculate new brightness
    NEW=$(echo "$CURRENT + $STEP" | bc)
    ;;
  down)
    # Calculate new brightness
    NEW=$(echo "$CURRENT - $STEP" | bc)
    ;;
  *)
    # Exit if the argument is invalid
    echo "Usage: $0 up|down"
    exit 1
    ;;
esac

# Set a minimum and maximum brightness to avoid errors
if (( $(echo "$NEW < 0.1" | bc -l) )); then
  NEW=0.1
elif (( $(echo "$NEW > 1.0" | bc -l) )); then
  NEW=1.0
fi

# Set the new brightness
xrandr --output "$OUTPUT" --brightness "$NEW"
