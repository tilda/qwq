#!/bin/bash

# -----------------------------------
# - qwq, light owo client for macos -
# -----------------------------------
# (c) slice 2017
# (c) tilda 2018 - linux compat

if [[ ! -f "$HOME/.config/qwq-token" ]]; then
  echo "Error: ~/.config/qwq-token not found."
fi

# --- configurables
# directory in which to store screenshots
SCREENSHOT_DIRECTORY="$HOME/Screenshots"

# your owo token, read from ~/.config/qwq-token
TOKEN=$(tr -d "\n" < ~/.config/qwq-token)

# file path
DATE_FORMAT="%m-%d-%Y-%I:%M:%S-%p"
SAVE_PATH="$SCREENSHOT_DIRECTORY/$(date +$DATE_FORMAT).png"

# vanity url to output
VANITY="owo.sh"
# ---

mkdir -p "$SCREENSHOT_DIRECTORY"

# screencap
maim -s "$SAVE_PATH"

# detect cancellation
if [[ "$?" == "1" ]]; then
  echo "Screencapture cancelled."
  exit 1
fi

echo "Saved to: $SAVE_PATH"

# upload
echo "Uploading..."
OWO_OUTPUT=$(curl -s -F "files[]=@\"$SAVE_PATH\";type=image/png" https://api.awau.moe/upload/pomf?key="$TOKEN" \
              -H "User-Agent: qwq.sh (for linux!) (https://github.com/(slice|tilda)")
echo "Uploaded!"

# upload to owo
FILE=$(echo "$OWO_OUTPUT" | jq -r ".files[0].url")
URL="https://$VANITY/$FILE"

# copy
echo -n "$URL" | xclip -i -sel c -f | xclip -i -sel p
echo "Copied to clipboard: $URL"

# notify
notify-send "qwq" "your picture was uploaded: $URL"
