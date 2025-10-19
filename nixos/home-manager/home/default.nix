{ lib, config, ... }: {
  config = lib.mkIf config.athena.baseConfiguration {
    home-manager.users.${config.athena.homeManagerUser} = { pkgs, ...}: {
      # It copies "./config/menus/xfce-applications.menu" source file to the nix store, and then symlinks it to the location.
      xdg.configFile."menus/blue-applications.menu".source = ./config/menus/blue-applications.menu;
      xdg.configFile."menus/red-applications.menu".source = ./config/menus/red-applications.menu;
      xdg.configFile."menus/mitre-applications.menu".source = ./config/menus/mitre-applications.menu;
      xdg.configFile."kando/config.json".source = ./config/kando/config.json;
      xdg.configFile."kando/menus.json".source = ./config/kando/menus.json;
    };
  };
}
