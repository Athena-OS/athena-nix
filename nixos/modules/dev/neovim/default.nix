{
  pkgs,
  lib,
  username,
  ...
}:
{
  home-manager.users.${username} = { pkgs, ...}: {
    home.packages = with pkgs; [
      #gcc # during nixos-install on Arch seems to produce an error. To delete.
      gnumake
      nodejs
      nodePackages.npm
      vscode-extensions.ms-vscode.cpptools
      vscode-extensions.vadimcn.vscode-lldb
    ];
    programs = {
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
      };
    };
    xdg.configFile."nvim/lua".source = ./lua;
    xdg.configFile."nvim/init.lua".source = ./init.lua;
  };
}
