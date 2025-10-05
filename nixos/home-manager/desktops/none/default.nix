{ lib, pkgs, config, ... }:
{
  config = lib.mkIf (config.athena.desktopManager == "none") {
    services.xserver.enable = lib.mkForce false;
    services.displayManager.enable = lib.mkForce false;
    services.flatpak.enable = lib.mkForce false;

    services.displayManager.gdm.enable = lib.mkForce false;
    services.displayManager.sddm.enable = lib.mkForce false;
    services.xserver.displayManager.lightdm.enable = lib.mkForce false;

    systemd.services.display-manager.enable = lib.mkForce false;
    systemd.defaultUnit = "multi-user.target";
  };
}
