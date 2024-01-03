# What is specified in the next line are the modules we expect to be here. home-manager here is passed by flake.nix
{ pkgs, home-manager, ... }:
{
  imports = [
    home-manager.nixosModules.home-manager
    ./hosts
    ./modules
    ./users
  ];
  environment.systemPackages = with pkgs; [
    netcat-openbsd
    unzip
    tree
    git
  ];
  nixpkgs.config.allowUnfree = true;
}
