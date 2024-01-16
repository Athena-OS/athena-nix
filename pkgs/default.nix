{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (callPackage ./athena-config { })
    (callPackage ./htb-toolkit { })
  ];
}
