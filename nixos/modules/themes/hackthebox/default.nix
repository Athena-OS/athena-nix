{ lib, pkgs, config, ... }:
let
  theme-components = {
    gtk-theme = "Matrix-Dark";
    icon-theme = "Matrix-Sweet";
    cursor-theme = "Afterglow-Recolored-Dracula-Green";
    background = "nix-hackthebox.png";
  };
  gtkTheme = "${theme-components.gtk-theme}";
  gtkIconTheme = "${theme-components.icon-theme}";
  gtkCursorTheme = "${theme-components.cursor-theme}";
in {
  config = lib.mkIf (config.athena.theme == "hackthebox") {
    athena.theme-components = theme-components;
    environment.systemPackages = with pkgs; [
      (callPackage ../../../pkgs/themes/athena-green-base/package.nix { })
    ];

    home-manager.users.${config.athena.homeManagerUser} = { pkgs, ...}: {
      # Needed to apply the theme on GTK4 windows (like Nautilus)
      home.sessionVariables.GTK_THEME = gtkTheme;

      gtk = {
        enable = true;
        gtk3.extraConfig.gtk-decoration-layout = "menu:";
        theme = {
          name = gtkTheme;
          package = pkgs.matrix-gtk-theme.override {
            colorVariants = [ "dark" ];
            tweakVariants = [ "macos" ];
            iconVariants = [ "Sweet" ];
          };
        };

        iconTheme = {
          name = gtkIconTheme;
        };

        cursorTheme = {
          name = gtkCursorTheme;
          package = pkgs.afterglow-cursors-recolored.override {
            themeVariants = [ "Dracula" ];
            draculaColorVariants = [ "Green" ];
          };
        };
      };

      programs = {
        kitty.themeFile = "Box";
        vscode = {
          extensions = with pkgs.vscode-extensions; [
            silofy.hackthebox
          ];

          # In case extensions are not loaded, refer to https://github.com/nix-community/home-manager/issues/3507
          userSettings = { "workbench.colorTheme" = "Hack The Box"; };
        };
      };
    };
  };
}
