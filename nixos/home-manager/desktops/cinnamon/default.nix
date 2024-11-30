{ lib, config, pkgs, ... }:
let
  cinnamon-packages = with pkgs; [
    ffmpeg
    gnome.gnome-screenshot
    xdg-user-dirs
    xdotool
    xorg.xdpyinfo
    xorg.xwininfo
  ];

  fontList = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  gtkTheme = "${config.athena.theme-components.gtk-theme}";
  gtkIconTheme = "${config.athena.theme-components.icon-theme}";
  gtkCursorTheme = "${config.athena.theme-components.cursor-theme}";
  backgroundTheme = "${config.athena.theme-components.background}";
in {
  config = lib.mkIf (config.athena.desktopManager == "cinnamon") {
    # ---- System Configuration ----
    services = {
      cinnamon.apps.enable = true;
      xserver = {
        enable = true;
        desktopManager = {
          cinnamon.enable = true;
        };
      };
    };

    xdg.portal.enable = true;
    environment = {
      pathsToLink = [ "/share/backgrounds" ]; # TODO: https://github.com/NixOS/nixpkgs/issues/47173
      systemPackages = cinnamon-packages;
    };

    # ---- Home Configuration ----
    home-manager.users.${config.athena.homeManagerUser} = { pkgs, ...}: {
      home.packages = fontList;
      dconf.settings = {
        "org/cinnamon/desktop/background" = {
          picture-uri = "file:///run/current-system/sw/share/backgrounds/athena/${backgroundTheme}";
          picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/athena/${backgroundTheme}";
        };

        "org/cinnamon/desktop/background" = {
          picture-options = "stretched";
        };

        "org/cinnamon/desktop/interface" = {
          gtk-theme = gtkTheme;
          icon-theme = gtkIconTheme;
          cursor-theme = gtkCursorTheme;
          color-scheme = "prefer-dark";
        };

        "org/cinnamon/desktop/wm/preferences" = {
          theme = gtkTheme;
        };
      };

      # It copies "./config/menus/gnome-applications.menu" source file to the nix store, and then symlinks it to the location.
      xdg.configFile = {
        "menus/applications-merged/cinnamon-applications.menu".source = ./config/menus/applications-merged/cinnamon-applications.menu;
        "cinnamon/spices/grouped-window-list@cinnamon.org/2.json".source = ./2.json;
      };

      dconf.settings = {
        "org/cinnamon" = {
          enabled-applets = [ "panel1:left:0:menu@cinnamon.org:0" "panel1:left:1:separator@cinnamon.org:1" "panel1:left:2:grouped-window-list@cinnamon.org:2" "panel1:right:0:systray@cinnamon.org:3" "panel1:right:1:xapp-status@cinnamon.org:4" "panel1:right:2:notifications@cinnamon.org:5" "panel1:right:3:printers@cinnamon.org:6" "panel1:right:4:removable-drives@cinnamon.org:7" "panel1:right:5:keyboard@cinnamon.org:8" "panel1:right:6:favorites@cinnamon.org:9" "panel1:right:7:network@cinnamon.org:10" "panel1:right:8:sound@cinnamon.org:11" "panel1:right:9:power@cinnamon.org:12" "panel1:right:10:calendar@cinnamon.org:13" "panel1:right:11:cornerbar@cinnamon.org:14" ];
          next-applet-id = 15;
        };
      };
    };
  };
}
