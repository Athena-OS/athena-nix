# This module defines a NixOS installation CD that contains X11 and
# XFCE.

{ pkgs, ... }:
let
  mate-packages = with pkgs.mate; [
    caja-with-extensions
    eom
    marco
    mate-control-center
    mate-desktop
    mate-media
    mate-netbook
    mate-panel
    mate-polkit
    mate-power-manager
    mate-session-manager
    mate-tweak
    mate-utils
  ];
in
{
  imports = [ ./installation-cd-graphical-base.nix ];

  isoImage.edition = "mate";

  services.xserver = {
    enable = true;
    desktopManager = {
      mate.enable = true;
    };
  };
  environment.pathsToLink = [
    "/share/backgrounds" # TODO: https://github.com/NixOS/nixpkgs/issues/47173
  ];
  environment.systemPackages = mate-packages ++ [
    pkgs.xdg-user-dirs
  ];
}