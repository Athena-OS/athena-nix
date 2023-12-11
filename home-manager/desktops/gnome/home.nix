{ home-manager, username, ... }:
{
  imports = [
    ./.
  ];
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";
}
