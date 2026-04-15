#!/usr/bin/env bash

# Ensure PATH (VERY IMPORTANT for SketchyBar)
export PATH="/run/current-system/sw/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

# Check if MPD is playing anything
if ! mpc status >/dev/null 2>&1; then
  icon=""
  output=""
else
  status="$(mpc status %state% 2>/dev/null)"

  if [ "$status" = "playing" ]; then
    icon=""
  else
    icon=""
  fi

  artist="$(mpc current -f %artist% 2>/dev/null)"
  song="$(mpc current -f %title% 2>/dev/null)"

  # Handle empty fields
  if [ -z "$artist" ] && [ -z "$song" ]; then
    output="No music"
  elif [ -z "$artist" ]; then
    output="$song"
  elif [ -z "$song" ]; then
    output="$artist"
  else
    output="$artist - $song"
  fi
fi

# Update SketchyBar
sketchybar --set mpd icon="$icon" label="$output"
