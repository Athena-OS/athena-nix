{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (callPackage ./athena-config/package.nix { })
    (callPackage ./cyber-toolnix/package.nix { })
    (callPackage ./htb-toolkit/package.nix { })
  ];
}
