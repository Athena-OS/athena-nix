# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  username = "athena";
  hostname = "athenaos";
  hm-version = "release-23.11"; # Correspond to home-manager GitHub branches
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/${hm-version}.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      {
        _module.args.username = username;
        _module.args.hostname = hostname;
      }
      (import "${home-manager}/nixos")
      ./hardware-configuration.nix # You need to generate or copy it to the same folder of configuration.nix
      ./modules/themes/graphite
      ./modules/desktops/gnome
      ./modules/dms/lightdm
      ./home-manager/desktops/gnome
      ./.
    ];
}
