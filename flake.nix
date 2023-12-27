{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager}@inputs:
    let
      theme = {
        gtk-theme = "Graphite-Dark";
        icon-theme = "Tela-circle-black-dark";
        cursor-theme = "Bibata-Modern-Ice";
      };
      mkSystem = extraModules:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          username = "athena";
          hostname = "athenaos";
          inherit (inputs) home-manager;
        }; # Using // attrs prevents the error 'infinite recursion due to home-manager usage in root default.nix
        modules = let
          modulesPath = "${self}/nixos/modules";
          #modulesPathNixPkgs = "${nixpkgs}/nixos/modules"; # Accessing remote NixOS/nixpkgs modules
        in
          [
            #"${modulesPath}/iso.nix"
            "/etc/nixos/hardware-configuration.nix"
            "${self}/." # It refers to the default.nix at root that imports in chain all the subfolder contents containing default.nix
            {
              _module.args.theme = theme;
            }
          ]
          ++ extraModules;
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
          "${self}/modules/dms/lightdm"
          "${self}/modules/themes/graphite"
          "${self}/home-manager/desktops/xfce/home.nix"
          #"${self}/home-manager/roles/osint"
        ];
        "gnome" = mkSystem [
          "${self}/modules/desktops/gnome"
          "${self}/modules/dms/lightdm"
          "${self}/home-manager/desktops/gnome"
          "${self}/modules/themes/graphite"
        ];
      };
  
      packages."x86_64-linux" =
        (builtins.mapAttrs (n: v: v.config.system.build.isoImage) self.nixosConfigurations)
        // {
          default = self.packages."x86_64-linux"."xfce";
        };
    };
}
