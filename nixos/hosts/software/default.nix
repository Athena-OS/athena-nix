{ lib, config, pkgs, ... }:
let
  utilities = with pkgs; [
    asciinema
    bat
    bfetch
    bind
    cmatrix
    cowsay
    cyberchef
    figlet
    file
    fortune
    ghex
    glxinfo
    gparted
    htb-toolkit
    hw-probe
    imagemagick
    lolcat
    lsd
    ncdu
    netcat-openbsd
    nixpkgs-review
    nyancat
    openvpn
    orca
    pciutils
    pfetch
    python3
    sl
    #https://github.com/NixOS/nixpkgs/pull/326142 ?
    #timeline
    toilet
    tree
    unzip
    wget
    xclip
    xcp
    zoxide
  ];

  devel = with pkgs; [ 
  #  cargo
  #  gcc
  #  jq
  #  killall
  #  python3
  ];

  exploits = with pkgs; [
    #powersploit
  ];

  wordlists = with pkgs; [
    #seclists
  ];
in
{
  imports = [
    ./goofcord
  ];

  config = lib.mkIf config.athena.baseSoftware {
    environment.systemPackages = devel ++ utilities ++ exploits ++ wordlists;
  };
}
