{ pkgs, home-manager, username, ... }:
{
  home-manager.users.${username} = { pkgs, ...}: {
    home.packages = with pkgs; [
        ddosify
        hyenae
        katana
        netsniff-ng
        siege
        slowhttptest
        slowlorust
        thc-ipv6
    ];
  };
}
