{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (callPackage ./athena-config { })
  ];
}
