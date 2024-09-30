{ lib, pkgs, config, ... }:
let
  theme-components = {
    gtk-theme = "Tokyonight-Dark";
    icon-theme = "FairyWren_Dark";
    cursor-theme = "oreo_blue_cursors";
    background = "temple.png";
  };
  gtkTheme = "${theme-components.gtk-theme}";
  gtkIconTheme = "${theme-components.icon-theme}";
  gtkCursorTheme = "${theme-components.cursor-theme}";
in {
  config = lib.mkIf (config.athena.theme == "temple") {
    athena.theme-components = theme-components;
    environment.systemPackages = with pkgs; [
      (callPackage ../../../pkgs/themes/athena-cyan-base/package.nix { })
    ];

    home-manager.users.${config.athena.homeManagerUser} = { pkgs, ...}: {
      # Needed to apply the theme on GTK4 windows (like Nautilus)
      home.sessionVariables.GTK_THEME = gtkTheme;

      gtk = {
        enable = true;
        gtk3.extraConfig.gtk-decoration-layout = "menu:";
        theme = {
          name = gtkTheme;
          package = pkgs.tokyonight-gtk-theme.override {
            colorVariants = [ "dark" ];
          };
        };

        iconTheme = {
          name = gtkIconTheme;
          package = pkgs.fairywren.override {
            colorVariants = [ "FairyWren_Dark" ];
          };
        };

        cursorTheme = {
          name = gtkCursorTheme;
          package = pkgs.oreo-cursors-plus;
        };
      };

      programs = {
        kitty.themeFile = "tokyo_night_storm";
        vscode = {
          extensions = with pkgs.vscode-extensions; [
            enkia.tokyo-night
          ];

          # In case extensions are not loaded, refer to https://github.com/nix-community/home-manager/issues/3507
          userSettings = { "workbench.colorTheme" = "Tokyo Night Storm"; };
        };
      };
    };
  };
}
