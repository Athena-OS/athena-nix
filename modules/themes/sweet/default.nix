{ pkgs, nixpkgs, home-manager, username, ... }:
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
      cursorTheme.name = "Bibata-Modern-Ice";
      iconTheme.package = pkgs.tela-circle-icon-theme.override {
        colorVariants = [ "black" ];
      };
      iconTheme.name = "Tela-circle-black-dark";
      theme.name = "Sweet-Dark-v40";
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
