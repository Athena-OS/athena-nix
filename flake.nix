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
          #modulesPathNixPkgs = "${nixpkgs}/nixos/modules"; # Accessing remote NixOS/nixpkgs modules
        in
          [
            #"${modulesPath}/iso.nix"
            #"/etc/nixos/hardware-configuration.nix"
          ];
      };
  in {
    nixosConfigurations = let
      modulesPath = "${self}/nixos/modules";
    in {
      "live-image" = mkSystem [
        "${modulesPath}/iso.nix"
      ];
      "xfce" = mkSystem [
        "${self}/modules/desktops/xfce"
      ];
      "gnome" = mkSystem [
        "${self}/modules/desktops/gnome"
      ];
    };

    packages."x86_64-linux" =
      (builtins.mapAttrs (n: v: v.config.system.build.isoImage) self.nixosConfigurations)
      // {
        default = self.packages."x86_64-linux"."xfce";
      };
  };
}