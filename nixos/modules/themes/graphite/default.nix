{ pkgs, nixpkgs, home-manager, username, theme, ... }:
let
  gtkTheme = "${theme.gtk-theme}";
  gtkIconTheme = "${theme.icon-theme}";
  gtkCursorTheme = "${theme.cursor-theme}";
in
{
  environment.systemPackages = with pkgs; [
    (callPackage ../../../pkgs/athena-graphite-theme/package.nix { })
  ];
  home-manager.users.${username} = { pkgs, ...}: {
    home.packages = with pkgs; [
      bibata-cursors
    ];
    gtk = {
      enable = true;
      gtk3.extraConfig.gtk-decoration-layout = "menu:";
      iconTheme.package = pkgs.tela-circle-icon-theme.override {
        colorVariants = [ "black" ];
      };
      theme.package = pkgs.graphite-gtk-theme.override {
        tweaks = [ "rimless" ];
      };
      iconTheme.name = gtkIconTheme;
      theme.name = gtkTheme;
      cursorTheme.name = gtkCursorTheme;
    };
    dconf.settings = {
        "org/gnome/desktop/background" = {
            "picture-uri" = "/run/current-system/sw/share/backgrounds/athena/nix-behind.png";
        };
        "org/gnome/desktop/background" = {
            "picture-uri-dark" = "/run/current-system/sw/share/backgrounds/athena/nix-behind.png";
        };
        "org/gnome/desktop/background" = {
            "picture-options" = "stretched";
        };
    };
    programs.kitty = {
      theme = "Atom";
    };
    programs.vscode = {
      extensions = with pkgs.vscode-extensions; [
        enkia.tokyo-night
      ];
      # In case extensions are not loaded, refer to https://github.com/nix-community/home-manager/issues/3507
      userSettings = {
        "workbench.colorTheme" = "Tokyo Night";
      };
    };
  };
}
