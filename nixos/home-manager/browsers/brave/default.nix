{ lib, config, ... }: {
  config = lib.mkIf (config.athena.browser == "brave") {
    home-manager.users.${config.athena.homeManagerUser} = { pkgs, ...}: {
      programs.chromium = {
        enable = true;
        # package = pkgs.firefox.override {cfg.enableTridactylNative = true;};
        package = pkgs.brave;
     };
  };
};
}
