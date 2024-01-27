{ pkgs, nixpkgs, home-manager, username, theme, ... }:
let
  gtkTheme = "${theme.gtk-theme}";
  gtkIconTheme = "${theme.icon-theme}";
  gtkCursorTheme = "${theme.cursor-theme}";
  backgroundTheme = "${theme.background}";
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
            "picture-uri" = "file:///run/current-system/sw/share/backgrounds/athena/"+backgroundTheme;
        };
        "org/gnome/desktop/background" = {
            "picture-uri-dark" = "file:///run/current-system/sw/share/backgrounds/athena/"+backgroundTheme;
        };
        "org/gnome/desktop/background" = {
            "picture-options" = "stretched";
        };

        "org/cinnamon/desktop/background" = {
            "picture-uri" = "file:///run/current-system/sw/share/backgrounds/athena/"+backgroundTheme;
        };
        "org/cinnamon/desktop/background" = {
            "picture-options" = "stretched";
        };
        "org/cinnamon/desktop/interface" = {
            "gtk-theme" = gtkTheme;
        };
        "org/cinnamon/desktop/wm/preferences" = {
            "theme" = gtkTheme;
        };
        "org/cinnamon/desktop/interface" = {
            "icon-theme" = gtkIconTheme;
        };
        "org/cinnamon/desktop/interface" = {
            "cursor-theme" = gtkCursorTheme;
        };

        "org/mate/desktop/interface" = {
            "gtk-theme" = gtkTheme;
        };
        "org/mate/marco/general" = {
            "theme" = gtkTheme;
        };
        "org/mate/desktop/interface" = {
            "icon-theme" = gtkIconTheme;
        };
        "org/mate/desktop/peripherals/mouse" = {
            "cursor-theme" = gtkCursorTheme;
        };
        "org/mate/desktop/background" = {
            "picture-filename" = "/run/current-system/sw/share/backgrounds/athena/"+backgroundTheme;
        };
    };
    programs.kitty = {
      theme = "Atom";
    };
    programs.vscode = {
      extensions = with pkgs.vscode-extensions; [
        nur.just-black
      ];
      # In case extensions are not loaded, refer to https://github.com/nix-community/home-manager/issues/3507
      userSettings = {
        "workbench.colorTheme" = "Just Black";
      };
    };
  };
}
