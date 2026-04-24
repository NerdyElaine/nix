{pkgs, ...}: {
  home.packages = [pkgs.aerospace];

  xdg.configFile."aerospace/aerospace.toml".text = ''
    start-at-login = true
    after-startup-command = [
      "exec-and-forget borders active_color=0xff6c7d5e inactive_color=0xff3c454c style=square width=8.0",
        "exec-and-forget sketchybar",
    ]
    enable-normalization-flatten-containers = true
    enable-normalization-opposite-orientation-for-nested-containers = true
    accordion-padding = 0
    default-root-container-layout = "tiles"
    default-root-container-orientation = "auto"
    key-mapping.preset = "qwerty"
    on-focused-monitor-changed = ["move-mouse monitor-lazy-center"]
    exec-on-workspace-change = [
        "/bin/bash",
        "-c",
        "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$(/run/current-system/sw/bin/aerospace list-workspaces --focused)"
    ]

    [gaps]
    inner.horizontal = 10
    inner.vertical = 10
    outer.left = 10
    outer.bottom = 10
    outer.top = 35
    outer.right = 10

    [mode.main.binding]
    alt-slash = "layout tiles horizontal vertical"
    alt-comma = "layout tiles horizontal horizontal"
    alt-shift-h = "move-mouse monitor-force-center"
    alt-shift-f = "fullscreen"

    alt-m = "focus left"
    alt-n = "focus down"
    alt-e = "focus up"
    alt-i = "focus right"

    ctrl-shift-m = "resize width -50"
    ctrl-shift-n = "resize height +50"
    ctrl-shift-e = "resize height -50"
    ctrl-shift-i = "resize width +50"

    alt-shift-m = "move left"
    alt-shift-n = "move down"
    alt-shift-e = "move up"
    alt-shift-i = "move right"

    ctrl-1 = "workspace 1"
    ctrl-2 = "workspace 2"
    ctrl-3 = "workspace 3"
    ctrl-4 = "workspace 4"
    ctrl-5 = "workspace 5"
    ctrl-6 = "workspace 6"
    ctrl-7 = "workspace 7"
    ctrl-8 = "workspace 8"
    ctrl-9 = "workspace 9"
    ctrl-0 = "workspace 10"
    ctrl-shift-alt-0 = "workspace 11"


    ctrl-alt-1 = "move-node-to-workspace 1"
    ctrl-alt-2 = "move-node-to-workspace 2"
    ctrl-alt-3 = "move-node-to-workspace 3"
    ctrl-alt-4 = "move-node-to-workspace 4"
    ctrl-alt-5 = "move-node-to-workspace 5"
    ctrl-alt-6 = "move-node-to-workspace 6"
    ctrl-alt-7 = "move-node-to-workspace 7"
    ctrl-alt-8 = "move-node-to-workspace 8"
    ctrl-alt-9 = "move-node-to-workspace 9"
    ctrl-alt-0 = "move-node-to-workspace 10"
    ctrl-shift-alt-cmd-0 = "move-node-to-workspace 11"
    ctrl-shift-h = "move-workspace-to-monitor --wrap-around next"

    alt-shift-space = "layout floating tiling"


    [[on-window-detected]]
    if.app-id = 'com.mitchellh.ghostty'
    run = 'move-node-to-workspace 1'

    [[on-window-detected]]
    if.app-id = 'net.ankiweb.launcher'
    run = 'move-node-to-workspace 2'

    [[on-window-detected]]
    if.app-id = 'org.nixos.firefox'
    run = 'move-node-to-workspace 3'

    [[on-window-detected]]
    if.app-id = 'in.cinny.app'
    run = 'move-node-to-workspace 4'

    [[on-window-detected]]
    if.app-id = 'dev.vencord.vesktop'
    run = 'move-node-to-workspace 4'

    [[on-window-detected]]
    if.app-id = 'ru.keepcoder.Telegram'
    run = 'move-node-to-workspace 5'

    [[on-window-detected]]
    if.app-id = 'com.automattic.beeper.desktop'
    run = 'move-node-to-workspace 5'

    [[on-window-detected]]
    if.app-id = 'com.apple.Notes'
    run = 'move-node-to-workspace 7'

    [[on-window-detected]]
    if.app-id = 'ch.protonvpn.mac'
    run = 'move-node-to-workspace 10'

    [[on-window-detected]]
    if.app-id = 'com.apple.Terminal'
    run = 'move-node-to-workspace 11'
  '';
}
