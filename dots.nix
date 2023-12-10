{ home-manager, ... }:
{
  imports = [
    home-manager.nixosModules.home-manager # to delete to avoid infinite recursion
    ./home-manager/desktops/xfce
  ];
  athena.desktops.xfce.enable = true;
}
