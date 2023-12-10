{ home-manager, ... }:
{
  imports = [
    ./home-manager/desktops/xfce
  ];
  home.username = "athena";
  home.homeDirectory = "/home/athena";
  home.stateVersion = "23.11";
  athena.desktops.xfce.refined = true;
}
