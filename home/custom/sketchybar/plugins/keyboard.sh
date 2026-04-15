#!/usr/bin/env sh

#
# Show current keyboard input source
#

# The most disgusting junk you will read, but it's for keyboard layout detection
SOURCE="$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | cut -c 33- | rev | cut -c 2- | rev)"

# specify short layouts individually.
case ${SOURCE} in
"\"U.S.\"") LABEL="US" ;;
"ABC") LABEL="EN" ;;
"\"qwerty-fr\"") LABEL="EN/FR" ;;
"Khmer") LABEL="KH" ;;
"Colemak") LABEL="CM" ;;
"\"Colemak DH ANSI\"") LABEL="CO" ;;
"\PinyinKeyboard\"") LABEL="CN" ;;
*) LABEL="한" ;;
esac

sketchybar --set $NAME label="$LABEL" icon='| 􀇳'
