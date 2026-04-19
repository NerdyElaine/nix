{
  pkgs,
  config,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "NerdyElaine";
        email = "167090657+NerdyElaine@users.noreply.github.com";
      };
    };
  };
}
