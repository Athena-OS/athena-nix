{ pkgs, home-manager, username, terminal, ... }:
let
  fontList = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "NerdFontsSymbolsOnly" ]; })
  ];
in
{
  home-manager.users.${username} = { pkgs, ...}: {
    home.packages = fontList;

    # It copies "./config/menus/gnome-applications.menu" source file to the nix store, and then symlinks it to the location.
    xdg.configFile."menus/applications-merged/applications-kmenuedit.menu".source = ./config/menus/applications-merged/applications-kmenuedit.menu;

    services.kdeconnect.enable = true;
  };
}
