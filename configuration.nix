# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  username = "athena";
  hostname = "athenaos";
  theme = "graphite";
  desktop = "gnome";
  dmanager = "lightdm";
  shell = "zsh";
  terminal = "kitty";
  browser = "firefox";
  role = "";
  hm-version = "release-23.11"; # Correspond to home-manager GitHub branches
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/${hm-version}.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      {
        _module.args.username = username;
        _module.args.hostname = hostname;
        _module.args.theme.module-name = theme;
        _module.args.desktop = desktop;
        _module.args.dmanager = dmanager;
        _module.args.shell = shell;
        _module.args.terminal = terminal;
        _module.args.browser = browser;
      }
      (import "${home-manager}/nixos")
      /etc/nixos/hardware-configuration.nix # You need to generate or copy it to the same folder of configuration.nix
      #./hardware-configuration.nix # You need to generate or copy it to the same folder of configuration.nix
      ./modules/desktops/${desktop}
      ./modules/dms/${dmanager}
      ./modules/themes/${theme}
      ./home-manager/desktops/${desktop}
      ./home-manager/terminals/${terminal}
      ./home-manager/browsers/${browser}
      ./home-manager/shells/${shell}
      ./.

      ./modules/roles/${role}
    ];
}
