{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    mkSystem = extraModules:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = let
          modulesPath = "${self}/nixos/modules";
        in
          [
            "${modulesPath}/iso.nix"
          ];
      };
  in {
    nixosConfigurations = let
      #packages = {pkgs, ...}: {environment.systemPackages = nixpkgs.lib.attrValues inputs.athenix.packages.${pkgs.system};};
    in {
      "live-image" = mkSystem [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.athena = import ./dots.nix;
          }
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