{ pkgs, ... }:
let 
  colors = {
          ## Everforest 
        "SK_BAR" = "0xff261c13";
        "SK_TEXT" = "0xff7c7b61";
        "SK_SPACE_HL_BG" = "0xff7d7e61";
        "SK_SPACE_HL_FG" = "0xff261c13";
        "SK_SPACE_OCCUPIED_FG" = "0xff887d4f";
        "SK_ITEM_BG" = "0xff261c13";
        "SK_BATTERY_CHARGING" = "0xffa6da95";
        "SK_SUBTEXT" = "0xffb8c0e0";
        "SK_BATTERY_LOW" = "0xffed8796";
      };

  aerospacePlugin = pkgs.writeShellScript "aerospace.sh" ''
    AEROSPACE="/run/current-system/sw/bin/aerospace"

    SID=$(echo "$NAME" | sed 's/space\.//')

    if [ -n "$FOCUSED_WORKSPACE" ]; then
      FOCUSED="$FOCUSED_WORKSPACE"
    else
      FOCUSED=$("$AEROSPACE" list-workspaces --focused 2>/dev/null || echo "1")
    fi

    if [ "$SID" = "$FOCUSED" ]; then
      sketchybar --set "$NAME" \
        background.color=${colors.SK_BATTERY_CHARGING} \
        icon.color=${colors.SK_SPACE_HL_FG}
        background.height=50 \
        background.width=50 
    else
      WINDOWS=$("$AEROSPACE" list-windows --workspace "$SID" 2>/dev/null | wc -l | tr -d ' ')
      if [ "$WINDOWS" -gt 0 ]; then
        sketchybar --set "$NAME" \
          background.color=${colors.SK_BAR} \
          background.height=50 \
          background.width=50 \
          icon.color=${colors.SK_TEXT}
      else
        sketchybar --set "$NAME" \
          background.color=${colors.SK_BAR} \
          background.height=50 \
          background.width=50 \
          icon.color=${colors.SK_TEXT}
      fi
    fi
  '';

  keyboardPlugin = pkgs.writeShellScript "keyboard.sh" ''
  # The most disgusting junk you will read, but it's for keyboard layout detection
    SOURCE="$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | cut -c 33- | rev | cut -c 2- | rev)"

# specify short layouts individually.
    case $SOURCE in
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
  '';

  cpuPlugin = pkgs.writeShellScript "cpu.sh" ''
    CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
    CPU_INFO=$(ps -eo pcpu,user)
    CPU_SYS=$(echo "$CPU_INFO" | grep -v $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")
    CPU_USER=$(echo "$CPU_INFO" | grep $(whoami) | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")

    CPU_PERCENT="$(echo "$CPU_SYS $CPU_USER" | awk '{printf "%.0f\n", ($1 + $2)*100}')"

    sketchybar --set $NAME label="$CPU_PERCENT% |"
  '';

  # Memory plugin script
  memoryPlugin = pkgs.writeShellScript "memory.sh" ''
    MEMORY=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print 100-$5}' | tr -d '%')
    sketchybar --set "$NAME" label="$MEMORY%"
  '';

  # Time plugin script
  timePlugin = pkgs.writeShellScript "time.sh" ''
    sketchybar --set $NAME label="| $(date '+%d/%m/%y | %H:%M')"
  '';

  # Disk plugin script
  diskPlugin = pkgs.writeShellScript "disk.sh"''
  sketchybar -m --set "$NAME" label="$(df -H | grep -E '^(/dev/disk3s5).' | awk '{ printf ("%s\n", $5) }')"
  '';

#mpd plugin
mpdPlugin = pkgs.writeShellScript "mpd.sh" ''
if [ $(mpc status | wc -l | tr -d ' ') == "1" ]; then
  output=""
  icon="  "
else
  artist=$(mpc current -f %artist%)
  song=$(mpc current -f %title%)
  status=$(mpc status %state%)

  if [ $status = "playing" ]; then
    icon=""
  else
    icon=""
  fi

  output="$artist - $song"
fi

echo $output
sketchybar -m --set mpd icon="$icon" \
              --set mpd label="$output"
'';

 # Battery plugin script
  batteryPlugin = pkgs.writeShellScript "power.sh" ''
        PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
        CHARGING=$(pmset -g batt | grep 'AC Power')

        ICON_HL=off

        if [[ $PERCENTAGE = "" ]]; then
            exit 0
        fi

        case $PERCENTAGE in
            [8-9][0-9]|7[6-9]|100)
                ICON="􀛨"
                ;;
            [6-7][0-9]|5[6-9])
                ICON="􀺸"
                ;;
            [3-5][0-9]|2[6-9])
                ICON="􀺶"
                ;;
            [1-2][0-9])
                ICON="􀛩"
                ;;
            *)
                ICON="􀛪"
                ICON_HL=on
                ICON_HL_COLOR=$BATTERY_LOW
        esac

# if [[ $INFO == "AC" ]]; then
        if [[ $CHARGING != "" ]]; then
            ICON="􀢋"
            ICON_HL=on
            ICON_HL_COLOR=$BATTERY_CHARGING
        fi

        sketchybar --set $NAME icon="$ICON" label="$PERCENTAGE%" icon.highlight=$ICON_HL icon.highlight_color=$ICON_HL_COLOR
  '';
  
  # Front app plugin script
  frontAppPlugin = pkgs.writeShellScript "front_app.sh" ''
    if [ "$SENDER" = "front_app_switched" ]; then
      sketchybar --set "$NAME" label="| $INFO"
    fi
  '';

  # Main configuration
  sketchybarConfig = ''
SK_BAR="${colors.SK_BAR}"
SK_TEXT="${colors.SK_TEXT}"
SK_SPACE_HL_BG="${colors.SK_SPACE_HL_BG}"
SK_SPACE_HL_FG="${colors.SK_SPACE_HL_FG}"
SK_SPACE_OCCUPIED_FG="${colors.SK_SPACE_OCCUPIED_FG}"
SK_ITEM_BG="${colors.SK_ITEM_BG}"
SK_BATTERY_CHARGING="${colors.SK_BATTERY_CHARGING}"
SK_SUBTEXT="${colors.SK_SUBTEXT}"
SK_BATTERY_LOW="${colors.SK_BATTERY_LOW}"

MONOSPACE_FONT='JetBrainsMono Nerd Font'
SANS_FONT='SF UI Text'

# Bar settings

sketchybar --bar height=23 \
                blur_radius=50 \
                position=top \
                padding_left=0 \
                padding_right=0 \
                margin=0 \
                y_offset=0 \
                corner_radius=0 \
                sticky=on \
                color="$SK_BAR"

sketchybar --default updates=when_shown \
                    drawing=on \
                    icon.font="$MONOSPACE_FONT:Regular:14.0" \
                    icon.color="$SK_TEXT" \
                    label.font="$SANS_FONT:Regular:14.5" \
                    label.padding_left=2 \
                    label.padding_right=2 \
                    icon.padding_left=3 \
                    icon.padding_right=5 \
                    background.padding_left=5 \
                    background.padding_right=5 \
                    background.corner_radius=0 \
                    label.color="$SK_TEXT" \
                    background.height=34

# AEROSPACE EVENT 

sketchybar --add event aerospace_workspace_change

############## LEFT ITEMS ##############

# Aerospace Workspaces
SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

for i in "''${!SPACE_ICONS[@]}"; do
    sid="''${SPACE_ICONS[$i]}"
    if [ "$sid" = "10" ]; then
        display_icon="10"
    else
        display_icon="$sid"
    fi

sketchybar --add item space.$sid left \
          --set space.$sid \
                icon="$display_icon" \
                icon.font="JetBrainsMono Nerd Font:REgular:14.0" \
                icon.color="$SK_TEXT" \
                icon.padding_left=10 \
                icon.padding_right=10 \
                label.padding_left="0" \
                label.padding_right="0" \
                background.padding_left=0 \
                background.padding_right=0 \
                background.color="$SK_BAR" \
                background.corner_radius=0 \
                background.height=50 \
                background.width=0 \
                click_script="aerospace workspace $sid" \
                script="${aerospacePlugin}" \
                update_freq=1 \
          --subscribe space.$sid aerospace_workspace_change
done

## Focused app name
sketchybar --add item front_app left \
        --set front_app script="${frontAppPlugin}" \
        icon.padding_left=0 \
        icon.padding_right=4 \
        icon.drawing=off \
        label.font="$MONOSPACE_FONT:Regular:13.0" \
        --subscribe front_app front_app_switched

#
# Right items
#

sketchybar --add item clock right \
  --set clock update_freq=5 \
  background.color="$SK_ITEM_BG" \
  icon.drawing=off\
  label.padding_left=2 \
  label.padding_right=12 \
  label.font="$MONOSPACE_FONT:Regular:14.0" \
  script="${timePlugin}" \
  background.padding_right=0 \
  \
  --add event input_change 'AppleSelectedInputSourcesChangedNotification' \
  --add item keyboard right \
  --set keyboard script="${keyboardPlugin}" \
  label.font="$MONOSPACE_FONT:Regular:14.5" \
  --subscribe keyboard input_change \
  \
  --add item battery right \
  --set battery script="BATTERY_LOW=$SK_BATTERY_LOW BATTERY_CHARGING=$SK_BATTERY_CHARGING ${batteryPlugin}" \
  label.font="$MONOSPACE_FONT:Regular:14.0" \
  update_freq=30 \
  --subscribe battery system_woke power_source_change \
  \
  --add item cpu right \
  --set cpu update_freq=2 \
  label.font="$MONOSPACE_FONT:Regular:14.0" \
  icon="| 􀧓 "\
  script="${cpuPlugin}"\
  \
	--add item ram right \
	--set ram update_freq=15 \
	label.font="$MONOSPACE_FONT:Regular:14.0" \
	icon="|  "\
	script="${memoryPlugin}" \
	\
	--add item disk right \
	--set disk update_freq=50 \
	label.font="$MONOSPACE_FONT:Regular:14.0" \
	icon="| 󰋊 "\
	script="${diskPlugin}" \
	\
  --add item mpd right \
  --set mpd update_freq=2 \
  --set mpd script="${mpdPlugin}" \
  label.font="$MONOSPACE_FONT:Regular:14.0" \
  --set mpd click_script="mpc toggle" \
  \

AEROSPACE="/run/current-system/sw/bin/aerospace"
FOCUSED=$("$AEROSPACE" list-workspaces --focused 2>/dev/null || echo "1")
sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$FOCUSED"

sketchybar --update
echo "sketchybar configuration loaded.."
  '';
  in
  {
  programs.sketchybar = {
    enable = pkgs.stdenv.isDarwin;
    package = pkgs.sketchybar;
    config = {
      text = sketchybarConfig;
    };
  };
}
