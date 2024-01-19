{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (callPackage ./athena-config { })
    (callPackage ./cyber-toolnix { })
    (callPackage ./htb-toolkit { })
  ];
}
