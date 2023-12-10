{ home-manager, ... }:
{
  imports = [
    home-manager.nixosModules.home-manager
    ./home-manager/desktops/xfce
  ];
  athena.desktops.xfce.enable = true;
}
