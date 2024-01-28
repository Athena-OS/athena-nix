# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  username = "athena";
  hashed = "$6$zjvJDfGSC93t8SIW$AHhNB.vDDPMoiZEG3Mv6UYvgUY6eya2UY5E2XA1lF7mOg6nHXUaaBmJYAMMQhvQcA54HJSLdkJ/zdy8UKX3xL1";
  hashedRoot = "$6$zjvJDfGSC93t8SIW$AHhNB.vDDPMoiZEG3Mv6UYvgUY6eya2UY5E2XA1lF7mOg6nHXUaaBmJYAMMQhvQcA54HJSLdkJ/zdy8UKX3xL1";
  hostname = "athenaos";
  theme = "sweet";
  desktop = "mate";
  dmanager = "gdm";
  shell = "fish";
  terminal = "kitty";
  browser = "firefox";
  bootloader = "systemd";
  hm-version = "release-23.11"; # Correspond to home-manager GitHub branches
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/${hm-version}.tar.gz";
in
{
  imports =
    [ # Include the results of the hardware scan.
      {
        _module.args.username = username;
        _module.args.hashed = hashed;
        _module.args.hashedRoot = hashedRoot;
        _module.args.hostname = hostname;
        _module.args.theme = theme;
        _module.args.desktop = desktop;
        _module.args.dmanager = dmanager;
        _module.args.shell = shell;
        _module.args.terminal = terminal;
        _module.args.browser = browser;
        _module.args.bootloader = bootloader;
      }
      (import "${home-manager}/nixos")
      /etc/nixos/hardware-configuration.nix
      ./modules/boot/${bootloader}
      ./modules/dms/${dmanager}
      ./modules/themes/${theme}
      ./home-manager/desktops/${desktop}
      ./home-manager/terminals/${terminal}
      ./home-manager/browsers/${browser}
      ./home-manager/shells/${shell}
      ./.

    ];

    /*virtualisation.vmware.host.enable = true;
    virtualisation.vmware.host.extraConfig = ''
      # Allow unsupported device's OpenGL and Vulkan acceleration for guest vGPU
      mks.gl.allowUnsupportedDrivers = "TRUE"
      mks.vk.allowUnsupportedDevices = "TRUE"
    '';*/
    /*virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;*/
}
