{ lib, pkgs, config, ... }:
{
  environment.systemPackages = lib.mkIf config.athena.baseConfiguration (with pkgs; [
    (callPackage ./athena-config-nix/package.nix { })
    (callPackage ./athena-welcome/package.nix { })
    (callPackage ./nist-feed/package.nix { })
  ]);
}
