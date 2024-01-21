{ pkgs, ... }:
{
  services.xserver.desktopManager.xfce.enable = true;
  programs.xfconf.enable = true;
  environment.systemPackages = with pkgs; [
    xfce.xfce4-cpugraph-plugin
    xfce.xfce4-docklike-plugin
    xfce.xfce4-genmon-plugin
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-settings
    xfce.xfce4-whiskermenu-plugin
  ];
}
