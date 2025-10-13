#!/bin/bash

# This script adjusts the PulseAudio volume and refreshes i3status.

STEP=5

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 up | down | mute | mic-mute"
  exit 1
fi

# Adjust volume based on the argument
case $1 in
  up)
    # Increase the volume by 5%
    pactl set-sink-volume @DEFAULT_SINK@ +$STEP%
    ;;
  down)
    # Decrease the volume by 5%
    pactl set-sink-volume @DEFAULT_SINK@ -$STEP%
    ;;
  mute)
    # Toggle mute for the default sink (speakers/headphones)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    ;;
  mic-mute)
    # Toggle mute for the default source (microphone)
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
    ;;
  *)
    echo "Invalid argument: $1"
    echo "Usage: $0 up | down | mute | mic-mute"
    exit 1
    ;;
esac

# Refresh the i3status bar
# The 'killall' command sends a specific signal (SIGUSR1) to the i3status process,
# telling it to refresh its data without restarting the entire process.
killall -SIGUSR1 i3status
