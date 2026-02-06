{ lib, config, pkgs, ... }: {
  config = lib.mkIf (config.athena.displayManager == "ly") {
    services.displayManager.ly = {
      enable = true;
      settings = {
          animation = "matrix";
          hide_version_string = true;
      };
    };
  };
}
