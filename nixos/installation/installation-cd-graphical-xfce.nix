# This module defines a NixOS installation CD that contains X11 and
# Plasma 5.

{ pkgs, ... }:

{
  imports = [ ./installation-cd-graphical-base.nix ];

  isoImage.edition = "gnome";

  services.xserver = {
    desktopManager = {
      gnome.enable = true;
    };
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = "athena";
      };
    };
  };
}