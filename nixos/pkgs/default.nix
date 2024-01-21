{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (callPackage ./aegis-nix/package.nix { })
    (callPackage ./athena-config/package.nix { })
    (callPackage ./athena-welcome/package.nix { })
    (callPackage ./cyber-toolnix/package.nix { })
    (callPackage ./htb-toolkit/package.nix { })
  ];
}
