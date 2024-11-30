{ lib, pkgs, config, ... }:
let
  fontList = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];

  bspwm-packages = with pkgs; [
     pfetch
     feh
     sxiv
     picom-next
     bspwm
     sxhkd
     polybar
     rofi
     pipes
     ranger
     pavucontrol
     maim
     killall
     mumble
     xclip
     ffmpeg
     mpv
     gimp
     lxappearance
  ];
in {
  config = lib.mkIf (config.athena.desktopManager == "bspwm") {
    # ---- System Configuration ----
    services = {
      mpd.enable = true;
      picom.enable = true;
      xserver = {
        enable = true;
        windowManager = {
          bspwm.enable = true;
        };
      };
    };

    environment = {
      pathsToLink = [ "/share/backgrounds" ]; # TODO: https://github.com/NixOS/nixpkgs/issues/47173
      systemPackages = bspwm-packages ++ fontList;
    };

    # ---- Home Configuration ----
    home-manager.users.${config.athena.homeManagerUser} = { pkgs, ...}: {
      programs.alacritty = {
          enable = true;
          settings = import ./alacritty;
      };

      # It copies "./config/menus/gnome-applications.menu" source file to the nix store, and then symlinks it to the location.
      xdg.configFile = {
        "bspwm".source = ./bspwm;
        "picom".source = ./picom;
        "polybar".source = ./polybar;
        "ranger".source = ./ranger;
        "rofi".source = ./rofi;
        "sxhkd".source = ./sxhkd;
      };
    };
  };
}
