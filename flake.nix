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
        module-name = "graphite";
        gtk-theme = "Graphite-Dark";
        icon-theme = "Tela-circle-black-dark";
        cursor-theme = "Bibata-Modern-Ice";
      };
      terminal = "kitty";
      mkSystem = extraModules:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          username = "athena";
          hostname = "athenaos";
          inherit (inputs) home-manager;
        }; # Using // attrs prevents the error 'infinite recursion due to home-manager usage in root default.nix
        modules = let
          modulesPath = "./nixos/modules";
          #modulesPathNixPkgs = "${nixpkgs}/nixos/modules"; # Accessing remote NixOS/nixpkgs modules
        in
          [
            #"${modulesPath}/iso.nix"
            "/etc/nixos/hardware-configuration.nix"
            home-manager.nixosModules.home-manager
            ./modules/themes/${theme.module-name}
            ./. # It refers to the default.nix at root that imports in chain all the subfolder contents containing default.nix
            {
              _module.args.theme = theme;
              _module.args.terminal = terminal;
            }
          ]
          ++ extraModules;
      };
    in {
      nixosConfigurations = let
        modulesPath = "./nixos/modules";
      in {
        "live-image" = mkSystem [
          "${modulesPath}/iso.nix"
        ];
        "xfce" = mkSystem [
          ./modules/desktops/xfce
          ./modules/dms/lightdm
          ./home-manager/desktops/xfce/home.nix
          ./home-manager/terminals/${terminal}
          ./home-manager/shells
          #./home-manager/roles/osint
        ];
        "gnome" = mkSystem [
          ./modules/desktops/gnome
          ./modules/dms/lightdm
          ./home-manager/desktops/gnome
          ./home-manager/terminals/${terminal}
          ./home-manager/shells
        ];
      };
  
      packages."x86_64-linux" =
        (builtins.mapAttrs (n: v: v.config.system.build.isoImage) self.nixosConfigurations)
        // {
          default = self.packages."x86_64-linux"."xfce";
        };
    };
}
