# In XFCE module, home.nix is used to set if implementing xfce.refined or xfce.picom
{ lib, pkgs, config, ... }: {
  config = lib.mkIf (config.athena.desktopManager == "xfce") {
    # ---- System Configuration ----
    services.xserver = {
      enable = true;
      desktopManager = {
        xfce = {
          enable = true;
          enableScreensaver = false;
        };
      };
    };

    programs.xfconf.enable = true;
    environment = {
      pathsToLink = [ "/share/backgrounds" ]; # TODO: https://github.com/NixOS/nixpkgs/issues/47173
      systemPackages = with pkgs.xfce; [
        xfce4-cpugraph-plugin
        xfce4-docklike-plugin
        xfce4-genmon-plugin
        xfce4-pulseaudio-plugin
        xfce4-settings
        xfce4-whiskermenu-plugin
      ];
    };

    # ---- Home Configuration ----
    home-manager.users.${config.athena.homeManagerUser} = { pkgs, ...}: {
      imports = [
        ./xfce.nix
      ];

      _module.args.theme = config.athena.theme;
      athena.desktops.xfce.refined = true;
    };
  };
}
