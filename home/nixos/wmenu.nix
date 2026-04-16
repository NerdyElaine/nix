{ config, pkgs, ... }:

let
  bg    = "#1e1e2e";
  fg    = "#cdd6f4";
  selbg = "#89b4fa";
  selfg = "#1e1e2e";
  font  = "monospace 11";

  wmenuRun = pkgs.writeShellScriptBin "wmenu-run-styled" ''
    exec ${pkgs.wmenu}/bin/wmenu-run \
      -f '${font}' \
      -N '${bg}'    -n '${fg}' \
      -M '${bg}'    -m '${fg}' \
      -S '${selbg}' -s '${selfg}'
  '';
in
{
  home.packages = [ pkgs.wmenu wmenuRun ];
  home.sessionVariables.WMENU_RUN = "${wmenuRun}/bin/wmenu-run-styled";
}
