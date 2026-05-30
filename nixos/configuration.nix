# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ lib, config, pkgs, ... }:
let
  # These variable names are used by Aegis backend
  version = "unstable"; #or 24.05
  username = "***REMOVED***";
  hashed = "REDACTED";
  hashedRoot = "REDACTED";
  hostname = "REDACTED";
  theme = "sweet";
  desktop = "cinnamon";
  dmanager = "sddm";
  mainShell = "fish";
  terminal = "alacritty";
  browser = "brave";
  bootloader = if builtins.pathExists "/sys/firmware/efi" then "systemd" else "grub";
  hm-version = if version == "unstable" then "master" else "release-" + version; # "master" or "release-24.05"; # Correspond to home-manager GitHub branches
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/${hm-version}.tar.gz";
in
{
  imports = [ # Include the results of the hardware scan.
    {
      athena = {
        inherit bootloader terminal theme mainShell browser;
        enable = true;
        homeManagerUser = username;
        baseConfiguration = true;
        baseSoftware = true;
        baseLocale = true;
        desktopManager = desktop;
        displayManager = dmanager;
      };
    }
    (import "${home-manager}/nixos")
    ./hardware-configuration.nix
    ./.

  ];

  users = lib.mkIf config.athena.enable {
    mutableUsers = false;
    extraUsers.root.hashedPassword = "${hashedRoot}";
    users.${config.athena.homeManagerUser} = {
      shell = pkgs.${config.athena.mainShell};
      isNormalUser = true;
      hashedPassword = "${hashed}";
      extraGroups = [ "wheel" "input" "video" "render" "networkmanager" "vboxusers"];
    };
  }; 
  networking = {
    hostName = "${hostname}";
    enableIPv6 = true;
  };
  #Enable Yubi Key
  services.pcscd.enable = true;
  services.udev.packages = [pkgs.yubikey-personalization ];
  security.pam = {
    u2f = {
      enable = true;
      settings = {
        cue = true;             #Prompt for device
        interactive = true;     #Prompt for missing key
        control = "sufficient"; #Only YubiKey, use "required" for 2FA
      };
    };
    services = {
      login.u2fAuth = true;  #login only
      sudo.u2fAuth = true;   #sudo too
    };
  };

  services.printing.drivers = [ pkgs.gutenprint pkgs.cnijfilter2 ];
  virtualisation.virtualbox = {
    host.enable = true;
    host.enableExtensionPack = true;
  };
  environment.systemPackages = with pkgs; [
   pkgs.inetutils #ftp and other tools
   usbutils	#Play with USB devices (lsusb, etc)
   postman          #API Hacking
   #mesaPackages.utils #for glxinfo
  ];
}
