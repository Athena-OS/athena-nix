{ config, lib, pkgs, theme, ... }:
with lib;
let
  cfg = config.athena.desktops.xfce;
  
  # pkgs.writeShellScriptBin and builtins.readFile are used to take the specified shell script that can be called and installed below by home-manager. There is no a target dir because home-manager will make them inside $PATH in order to be called
  genmon-cpu = pkgs.writeShellScriptBin "genmon-cpu"
    (builtins.readFile ./bin/genmon-cpu);
  genmon-datetime = pkgs.writeShellScriptBin "genmon-datetime"
    (builtins.readFile ./bin/genmon-datetime);
  genmon-mem = pkgs.writeShellScriptBin "genmon-mem"
    (builtins.readFile ./bin/genmon-mem);
  i3lock-everblush = pkgs.writeShellScriptBin "i3lock-everblush"
    (builtins.readFile ./bin/i3lock-everblush);
  xfce-init = pkgs.writeShellScriptBin "xfce-init"
    (builtins.readFile ./bin/xfce-init);
in
{
  xdg.dataFile."icons/assets".source = ./assets;
  xdg.dataFile."fonts/feather.ttf".source = ./fonts/feather.ttf;
  xdg.configFile."picom/picom.conf".source = ./config/picom/picom.conf;

  # It copies "./config/menus/xfce-applications.menu" source file to the nix store, and then symlinks it to the location.
  xdg.configFile."menus/blue-applications.menu".source = ./config/menus/blue-applications.menu;
  xdg.configFile."menus/red-applications.menu".source = ./config/menus/red-applications.menu;

  # Everblush xfwm4 theme
  # home.file refers to $HOME dir
  home.file.".bash_aliases".source = ./bash_aliases;
  home.file.".blerc".source = ./blerc;
}