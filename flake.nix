{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      username = "athena";
      theme = "graphite";
      desktop = "mate";
      dmanager = "lightdm";
      shell = "bash";
      terminal = "alacritty";
      browser = "firefox";
      bootloader = "systemd";
      mkSystem = extraModules:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({ config, pkgs, ...}: let
            hostname = "athenaos";
            hashed = "$6$zjvJDfGSC93t8SIW$AHhNB.vDDPMoiZEG3Mv6UYvgUY6eya2UY5E2XA1lF7mOg6nHXUaaBmJYAMMQhvQcA54HJSLdkJ/zdy8UKX3xL1";
            hashedRoot = "$6$zjvJDfGSC93t8SIW$AHhNB.vDDPMoiZEG3Mv6UYvgUY6eya2UY5E2XA1lF7mOg6nHXUaaBmJYAMMQhvQcA54HJSLdkJ/zdy8UKX3xL1";
          in {
            networking.hostName = "${hostname}";
            users = {
              mutableUsers = false;
              extraUsers.root.hashedPassword = "${hashedRoot}";
              users.${config.athena-nix.homeManagerUser} = {
                shell = pkgs.${config.athena-nix.shell};
                isNormalUser = true;
                hashedPassword = "${hashed}";
                extraGroups = [ "wheel" "input" "video" "render" "networkmanager" ];
              };
            };
          })
        ] ++ extraModules;
      };
    in {
      nixosConfigurations = {
        # nix build .#nixosConfigurations.live-image.config.system.build.isoImage
        "live-image" = mkSystem [
          ./nixos/installation/iso.nix
          home-manager.nixosModules.home-manager
          ./nixos
          {
            athena-nix = {
              enable = true;
              homeManagerUser = "athena";
              baseHosts = true;
              desktopManager = "mate";
              terminal = "alacritty";
              theme = "graphite";
            };
          }
        ];

        "runtime" = mkSystem [
          "/etc/nixos/hardware-configuration.nix"
          home-manager.nixosModules.home-manager
          ./nixos
          {
            athena-nix = {
              inherit terminal theme shell browser;
              enable = true;
              homeManagerUser = username;
              baseConfiguration = true;
              baseSoftware = true;
              desktopManager = desktop;
              bootLoader = bootloader;
              displayManager = dmanager;
            };
          }
        ];

        "student" = mkSystem [
          "/etc/nixos/hardware-configuration.nix"
          ./nixos/modules/roles/student
        ];
      };

      packages."x86_64-linux" =
        (builtins.mapAttrs (n: v: v.config.system.build.isoImage) self.nixosConfigurations) // {
          default = self.packages."x86_64-linux"."live-image";
        };
    };
}
