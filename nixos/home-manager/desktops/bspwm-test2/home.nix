{ config, lib, pkgs, inputs, username, ... }:
{

  imports = [
    ./apps.nix
    ./modules/desk-env/bspwm/home.nix
    ./modules/desk-env/sxhkd/home.nix
    ./modules/rofi/home.nix
    ./modules/picom/home.nix
    ./modules/feh/home.nix
    ./modules/fcitx5/home.nix
  ];

  home = {
    homeDirectory = "/home/athena";
    file = {
      ".profile" = {
	recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink ./conf/profile;
      };
      ".config/polybar" = {
	recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink ./conf/polybar;
      };
      ".local/share/fonts" = {
	recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink ./conf/fonts;
      };
      ".local/share/fcitx5" = {
	recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink ./conf/fcitx5;
      };
      "Pictures/wallpapers" = {
	recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink ./conf/wallpapers;
      };
      ".config/rofi/nord.rasi" = {
	recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink ./conf/rofi/nord.rasi;
      };
      ".config/cava" = {
	recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink ./conf/cava;
      };
      ".config/mpd/mpd.conf" = {
	recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink ./conf/mpd/mpd.conf;
      };
      ".config/ncmpcpp/config" = {
	recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink ./conf/ncmpcpp/config;
      };
      ".config/dunst" = {
	recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink ./conf/dunst;
      };
      ".config/fontconfig/fonts.conf" = {
	recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink ./conf/fontconfig/fonts.conf;
      };
      "Music/jack-pathbays" = {
	recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink ./conf/jack-pathbays;
      };
      "Music/jack-sessions" = {
	recursive = true;
        source = config.lib.file.mkOutOfStoreSymlink ./conf/jack-sessions;
      };
    };
  };
}
