{ pkgs, ... }:
{
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  #environment.systemPackages = with pkgs; [
  #  xfce.xfce4-cpugraph-plugin
  #  xfce.xfce4-pulseaudio-plugin
  #  xfce.xfce4-settings
  #  xfce.xfce4-whiskermenu-plugin
  #];
}