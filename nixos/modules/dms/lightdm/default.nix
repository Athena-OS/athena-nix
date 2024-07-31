{ lib, config, ... }: {
  config = lib.mkIf (config.athena.displayManager == "lightdm") {
    services.xserver.displayManager.lightdm = {
      enable = true;
      greeters.slick.enable = true;
    };
  };
}
