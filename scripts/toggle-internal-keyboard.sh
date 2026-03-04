#!/usr/bin/env bash

DEVICE="/sys/devices/platform/i8042/serio0/input/input3/inhibited"

if [ ! -f "$DEVICE" ]; then
  echo "Keyboard device not found!"
  exit 1
fi

STATE=$(cat "$DEVICE")

if [ "$STATE" -eq 0 ]; then
  echo "Disabling internal keyboard..."
  echo 1 | sudo tee "$DEVICE" >/dev/null
  echo "Disabled."
else
  echo "Enabling internal keyboard..."
  echo 0 | sudo tee "$DEVICE" >/dev/null
  echo "Enabled."
fi
