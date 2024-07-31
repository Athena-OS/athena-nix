{ lib, config, ...}: {
  config = lib.mkIf config.athena.baseConfiguration {
    home-manager.users.${config.athena.homeManagerUser} = { pkgs, ...}: {
      programs.starship = {
        enable = false;
        enableZshIntegration = false;
      };
    };
  };
}
