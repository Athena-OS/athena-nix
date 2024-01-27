{ pkgs, nixpkgs, home-manager, username, theme-components, ... }:
let
  theme-components = {
    gtk-theme = "Sweet-Dark-v40";
    icon-theme = "candy-icons";
    cursor-theme = "Bibata-Modern-Ice";
    background = "neon-circle.jpg";
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
    (callPackage ../../../pkgs/athena-sweet-theme/package.nix { })
  ];
  home-manager.users.${username} = { pkgs, ...}: {
    home.packages = with pkgs; [
      bibata-cursors
    ];
    xdg.configFile."gtk-4.0/gtk.css".source = ./gtk.css;
    gtk = {
      enable = true;
      gtk3.extraConfig.gtk-decoration-layout = "menu:";
      iconTheme.package = pkgs.candy-icons;
      iconTheme.name = gtkIconTheme;
      theme.name = gtkTheme;
      cursorTheme.name = gtkCursorTheme;
    };
    programs.kitty = {
      theme = "Adventure Time";
    };
    programs.vscode = {
      extensions = with pkgs.vscode-extensions; [
        dhedgecock.radical-vscode
      ];
      # In case extensions are not loaded, refer to https://github.com/nix-community/home-manager/issues/3507
      userSettings = {
        "workbench.colorTheme" = "Radical";
      };
    };
  };
}
