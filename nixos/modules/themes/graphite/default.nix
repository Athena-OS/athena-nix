{ lib, pkgs, config, ... }:
let
  theme-components = {
    gtk-theme = "Graphite-Dark";
    icon-theme = "Tela-circle-black-dark";
    cursor-theme = "Bibata-Modern-Ice";
    background = "nix-behind.png";
  };
  gtkTheme = "${theme-components.gtk-theme}";
  gtkIconTheme = "${theme-components.icon-theme}";
  gtkCursorTheme = "${theme-components.cursor-theme}";
in {
  config = lib.mkIf (config.athena.theme == "graphite") {
    athena.theme-components = theme-components;
    environment.systemPackages = with pkgs; [
      (callPackage ../../../pkgs/themes/athena-blue-base/package.nix { })
    ];

    home-manager.users.${config.athena.homeManagerUser} = { pkgs, ...}: {
      # Needed to apply the theme on GTK4 windows (like Nautilus)
      home.sessionVariables.GTK_THEME = gtkTheme;

      gtk = {
        enable = true;
        gtk3.extraConfig.gtk-decoration-layout = "menu:";
        theme = {
          name = gtkTheme;
          package = pkgs.graphite-gtk-theme.override {
            tweaks = [ "rimless" ];
          };
        };

        iconTheme = {
          name = gtkIconTheme;
          package = pkgs.tela-circle-icon-theme.override {
            colorVariants = [ "black" ];
          };
        };

        cursorTheme = {
          name = gtkCursorTheme;
          package = pkgs.bibata-cursors;
        };
      };

      programs = {
        kitty.themeFile = "Atom";
        vscode = {
          extensions = with pkgs.vscode-extensions; [
            nur.just-black
          ];

          # In case extensions are not loaded, refer to https://github.com/nix-community/home-manager/issues/3507
          userSettings = { "workbench.colorTheme" = "Just Black"; };
        };
      };
    };
  };
}
