{ pkgs, nixpkgs, home-manager, username, theme-components, ... }:
let
  theme-components = {
    gtk-theme = "Graphite-Dark";
    icon-theme = "Tela-circle-black-dark";
    cursor-theme = "Bibata-Modern-Ice";
    background = "nix-behind.jpg";
  };
  gtkTheme = "${theme-components.gtk-theme}";
  gtkIconTheme = "${theme-components.icon-theme}";
  gtkCursorTheme = "${theme-components.cursor-theme}";
  backgroundTheme = "${theme-components.background}";
in
{
  imports =
    [
      {
        _module.args.theme-components = theme-components;
      }
    ];
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
