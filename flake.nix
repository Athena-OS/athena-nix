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
        module-name = "sweet";
        gtk-theme = "Sweet-Dark-v40";
        icon-theme = "Tela-circle-black-dark";
        cursor-theme = "Bibata-Modern-Ice";
      };
      desktop = "gnome";
      dmanager = "gdm";
      shell = "fish";
      terminal = "kitty";
      browser = "firefox";
      mkSystem = extraModules:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          username = "athena";
          hostname = "athenaos";
          hashed = "athena";
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
            ./. # It refers to the default.nix at root that imports in chain all the subfolder contents containing default.nix
            ./modules/desktops/${desktop}
            ./modules/dms/${dmanager}
            ./modules/themes/${theme.module-name}
            ./home-manager/desktops/${desktop}
            ./home-manager/terminals/${terminal}
            ./home-manager/browsers/${browser}
            ./home-manager/shells/${shell}
            {
              _module.args.theme = theme;
              _module.args.dmanager = dmanager;
              _module.args.desktop = desktop;
              _module.args.shell = shell;
              _module.args.terminal = terminal;
              _module.args.browser = browser;
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
        "gnome" = mkSystem [
          #./modules/roles/osint
        ];
        "xfce" = mkSystem [
          #./modules/roles/osint
        ];
        "network" = mkSystem [
          ./modules/roles/network
        ];
      };
  
      packages."x86_64-linux" =
        (builtins.mapAttrs (n: v: v.config.system.build.isoImage) self.nixosConfigurations)
        // {
          default = self.packages."x86_64-linux"."xfce";
        };
    };
}
