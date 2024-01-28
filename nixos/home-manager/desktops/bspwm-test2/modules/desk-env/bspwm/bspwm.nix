{ config, lib, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;
      desktopManager.xfce = {
	      thunarPlugins = with pkgs; [
          xfce.thunar-archive-plugin
          xfce.thunar-volman
          xfce.thunar-media-tags-plugin
        ];
      };
      windowManager = {
        bspwm = {
	        enable = true;
	      };
        defaultSession = "none+bspwm";
      };
    };
  };
}
