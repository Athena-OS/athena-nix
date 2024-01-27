{ pkgs, ... }:
let
  cinnamon-packages = with pkgs; [
    ffmpeg
    gnome.gnome-screenshot
    xdg-user-dirs
    xdotool
    xorg.xdpyinfo
    xorg.xwininfo
  ];
in
{
  services = {
    cinnamon.apps.enable = true;
    xserver = {
      enable = true;
      desktopManager = {
        cinnamon.enable = true;
      };
    };
  };
  environment.pathsToLink = [
    "/share/backgrounds" # TODO: https://github.com/NixOS/nixpkgs/issues/47173
  ];
  environment.systemPackages = cinnamon-packages;
}