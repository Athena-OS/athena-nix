{ pkgs, nixpkgs, home-manager, username, ... }:
let
  gtkTheme = "Sweet-Dark-v40";
  gtkIconTheme = "Tela-circle-black-dark";
  gtkCursorTheme = "Bibata-Modern-Ice";
in
{
  environment.systemPackages = with pkgs; [
    (callPackage ../../../pkgs/athena-sweet-theme { })
  ];
  home-manager.users.${username} = { pkgs, ...}: {
    home.packages = with pkgs; [
      bibata-cursors
      #sweet
    ];
    xdg.configFile."gtk-4.0/gtk.css".source = ./gtk.css;
    gtk = {
      enable = true;
      gtk3.extraConfig.gtk-decoration-layout = "menu:";
      iconTheme.package = pkgs.tela-circle-icon-theme.override {
        colorVariants = [ "black" ];
      };
      iconTheme.name = gtkIconTheme;
      theme.name = gtkTheme;
      cursorTheme.name = gtkCursorTheme;
    };
    dconf.settings = {
        "org/gnome/desktop/background" = {
            "picture-uri" = "/run/current-system/sw/share/backgrounds/athena/neon-circle.jpg";
        };
        "org/gnome/desktop/background" = {
            "picture-uri-dark" = "/run/current-system/sw/share/backgrounds/athena/neon-circle.jpg";
        };
        "org/gnome/desktop/background" = {
            "picture-options" = "stretched";
        };
    };
    programs.kitty = {
      theme = "Adventure Time";
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
