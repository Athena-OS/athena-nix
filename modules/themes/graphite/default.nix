{ pkgs, nixpkgs, home-manager, username, ... }:
{

  home-manager.users.${username} = { pkgs, ...}: {
    home.packages = with pkgs; [
      bibata-cursors
    ];
    gtk = {
      enable = true;
      gtk3.extraConfig.gtk-decoration-layout = "menu:";
      cursorTheme.name = "Bibata-Modern-Ice";
      iconTheme.package = pkgs.tela-circle-icon-theme.override {
        colorVariants = [ "black" ];
      };
      iconTheme.name = "Tela-circle-black-dark";
      theme.package = pkgs.graphite-gtk-theme.override {
        tweaks = [ "rimless" ];
      };
      theme.name = "Graphite-Dark";
    };
  };
  environment.systemPackages = with pkgs; [
    (callPackage ../../../pkgs/athena-graphite-theme { })
  ];
}