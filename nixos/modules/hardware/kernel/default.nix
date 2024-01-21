{ config, pkgs, ... }:
{
  # If change kernel, remember to run 'sudo nixos-rebuild boot' and 'sudo reboot'
  boot.kernelPackages = pkgs.linuxPackages; # LTS Kernel
  boot.extraModulePackages = with config.boot.kernelPackages; [ vmware ];
}