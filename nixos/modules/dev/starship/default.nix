{ config, ...}: {
  home-manager.users.${config.athena-nix.homeManagerUser} = { pkgs, ...}: {
    programs.starship = {
      enable = false;
      enableZshIntegration = false;
    };
  };
}
