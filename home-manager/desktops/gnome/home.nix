{ home-manager, ... }:
{
  imports = [
    ./.
  ];
  home.username = "athena";
  home.homeDirectory = "/home/athena";
  home.stateVersion = "23.11";
}
