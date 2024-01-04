{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (callPackage ./athena-config { })
    (callPackage ./athena-graphite-theme { })
    netcat-openbsd
    unzip
    tree
    git
    file
    nmap
    lsd
    bat
    alacritty
  ];
}
