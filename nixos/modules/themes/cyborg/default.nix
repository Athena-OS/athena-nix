{ lib, pkgs, config, ... }:
let
  theme-components = {
    gtk-theme = "Gruvbox-Dark";
    icon-theme = "Material-Black-Mango-Suru";
    cursor-theme = "Fuchsia-Pop";
    background = "cyborg-gruv.png";
  };
  gtkTheme = "${theme-components.gtk-theme}";
  gtkIconTheme = "${theme-components.icon-theme}";
  gtkCursorTheme = "${theme-components.cursor-theme}";
in {
  config = lib.mkIf (config.athena.theme == "cyborg") {
    athena.theme-components = theme-components;
    environment.systemPackages = with pkgs; [
      (callPackage ../../../pkgs/themes/athena-gruvbox-base/package.nix { })
    ];

    home-manager.users.${config.athena.homeManagerUser} = { pkgs, ...}: {
      # Needed to apply the theme on GTK4 windows (like Nautilus)
      home.sessionVariables.GTK_THEME = gtkTheme;

      gtk = {
        enable = true;
        gtk3.extraConfig.gtk-decoration-layout = "menu:";
        theme = {
          name = gtkTheme;
          package = pkgs.gruvbox-gtk-theme.override {
            colorVariants = [ "dark" ];
          };
        };

        iconTheme = {
          name = gtkIconTheme;
          package = pkgs.material-black-colors.override {
            colorVariants = [ "Material-Black-Mango-Suru" ];
          };
        };

        cursorTheme = {
          name = gtkCursorTheme;
          package = pkgs.fuchsia-cursor.override {
            themeVariants = [ "Fuchsia-Pop" ];
            platformVariants = [ "x11" ];
          };
        };
      };

      programs = {
        kitty.themeFile = "gruvbox-dark";
        vscode = {
          extensions = with pkgs.vscode-extensions; [
            jdinhlife.gruvbox
          ];

          # In case extensions are not loaded, refer to https://github.com/nix-community/home-manager/issues/3507
          userSettings = { "workbench.colorTheme" = "Gruvbox Dark Hard"; };
        };
      };
    };
  };
}
