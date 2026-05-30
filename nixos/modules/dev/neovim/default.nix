{ lib, config, ... }: {
#{lib, config, pkgs, pinnedNodejs ? pkgs.nodejs, ... }: {
  config = lib.mkIf config.athena.baseConfiguration {
    home-manager.users.${config.athena.homeManagerUser} = { pkgs, ...}: {
      home.packages = with pkgs; [
        #gcc # during nixos-install on Arch seems to produce an error. To delete.
        gnumake
        nodejs #pinnedNodejs
        #npm
        vscodium-extensions.ms-vscodium.cpptools
        vscodium-extensions.vadimcn.vscodium-lldb
      ];
      programs = {
        neovim = {
          enable = true;
          viAlias = true;
          vimAlias = true;
          withPython3 = true;
          withRuby = true;
        };
      };
      xdg.configFile."nvim/lua".source = ./lua;
      xdg.configFile."nvim/init.lua".source = ./init.lua;
    };
  };
}
