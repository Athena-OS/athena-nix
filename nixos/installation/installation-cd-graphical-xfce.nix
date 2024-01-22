# This module defines a NixOS installation CD that contains X11 and
# XFCE.

{ pkgs, ... }:

{
  imports = [ ./installation-cd-graphical-base.nix ];

  isoImage.edition = "xfce";

  services.xserver = {
    desktopManager = {
      xfce = {
        enable = true;
        enableScreensaver = false;
      };
    };
    displayManager = {
      lightdm.enable = true;
      autoLogin = {
        enable = true;
        user = "athena";
      };
    };
  };
}