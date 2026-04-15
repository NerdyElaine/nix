{ config, pkgs, lib, ... }:
{
  environment.systemPackages = [ pkgs.aerospace ];

  launchd.user.agents.aerospace = {
    serviceConfig = {
      ProgramArguments = [ "${pkgs.aerospace}/bin/aerospace" ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}
