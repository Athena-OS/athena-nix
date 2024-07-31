{ lib, config, ... }: {
  config = lib.mkIf config.athena.baseConfiguration {
    networking.networkmanager.enable = true;
    services.vnstat.enable = true;
    users.users.${config.athena.homeManagerUser} = {
      extraGroups = [ "networkmanager" ];
    };
  };
}
