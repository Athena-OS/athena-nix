{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    athenix = {
      url = "github:Athena-OS/athena-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    mkSystem = extraModules:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = let
          modulesPath = "./nixos/modules";
        in
          [
            "${modulesPath}/iso.nix"

            ./dots.nix
          ]
          ++ extraModules;
      };
  in {
    nixosConfigurations = let
      #packages = {pkgs, ...}: {environment.systemPackages = nixpkgs.lib.attrValues inputs.athenix.packages.${pkgs.system};};
    in {
      "AthenaOS-xfce" = mkSystem [
        ./dots.nix
        #packages
      ];#AthenaOS-xfce
      /*"AthenaOS-xfce-light" = mkSystem [
        ./xfce.nix
      ];
      "AthenaOS-kde" = mkSystem [
        ./kde.nix
        #packages
      ];
      "AthenaOS-kde-light" = mkSystem [
        ./kde.nix
      ];
      "AthenaOS-headless" = mkSystem [
        #packages
      ];*/
    };

    packages."x86_64-linux" =
      (builtins.mapAttrs (n: v: v.config.system.build.isoImage) self.nixosConfigurations)
      // {
        default = self.packages."x86_64-linux"."AthenaOS-xfce";
      };
  };
}