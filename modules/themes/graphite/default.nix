{ pkgs, nixpkgs, home-manager, username, ... }:
{
  environment.systemPackages = with pkgs; [
    bibata-cursors
    graphite-gtk-theme
    tela-circle-icon-theme
  ];

  home-manager.users.${username} = { pkgs, ...}: {
    gtk = {
      enable = true;
      gtk3.extraConfig.gtk-decoration-layout = "menu:";
      cursorTheme.name = "Bibata-Modern-Ice";
      iconTheme.name = "Tela-circle-dark";
      theme.name = "Graphite-Dark";
    };
  };
}