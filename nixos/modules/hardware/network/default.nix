{ config, ... }:
{
  networking.networkmanager.enable = true;
  services.vnstat.enable = true;
  users.users.${config.athena-nix.homeManagerUser} = {
    extraGroups = [ "networkmanager" ];
  };
}
