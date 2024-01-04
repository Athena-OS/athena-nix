{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (callPackage ./athena-config { })
    (callPackage ./athena-graphite-theme { })
  ];
}
