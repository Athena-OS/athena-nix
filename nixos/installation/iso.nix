{ pkgs, lib, ... }: {

  imports = [
    ./installation-cd-graphical-xfce.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "rtl8821cu" ];
    loader.grub.useOSProber = true;
  };

  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "ext4" "f2fs" "xfs" "ntfs" "cifs" ];

  hardware = {
    cpu.amd.updateMicrocode = true;
    cpu.intel.updateMicrocode = true;
    bluetooth.enable = true;
    #enableAllFirmware = true; # Need allowUnfree = true
    enableRedistributableFirmware = true;
    opengl = {
      enable = true;
    };
  };

  services = {
    timesyncd = {
      # feel free to change to sth around your location
      # servers = ["pl.pool.ntp.org"];
      enable = true;
    };

    printing.enable = false;
    vnstat.enable = true;

    avahi = {
      enable = true;
      browseDomains = [];
      wideArea = false;
      nssmdns4 = true;
    };

    unbound = {
      enable = true;
      settings.server = {
        access-control = [];
        interface = [];
      };
    };

    hardware = {
      bolt.enable = true;
    };
  };

  networking = {
    hostName = "athenaos";
    dhcpcd.enable = true;
    networkmanager.dhcp = "dhcpcd";
    firewall = {
      #allowedTCPPorts = [22 80];
      #allowPing = false;
      checkReversePath = "loose";
      enable = true;
      logReversePathDrops = true;
      # trustedInterfaces = [ "" ];
    };
  };

  #time.timeZone = "UTC"; # change to your one

  # locales as well
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # nix config
  nix = {
    package = pkgs.nixUnstable;
    settings = {
      extra-experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = ["@wheel"]; #locks down access to nix-daemon
    };
  };

  programs = {
    git.enable = true;
    nano.enable = true;
    xfconf.enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #   home-manager
  #   dialog
  #   dosfstools
  #   edk2-uefi-shell
  #   inetutils
  #   mkinitcpio-nfs-utils
  #   nettools
  #   networkmanagerapplet
  #   ##nfs-utils ./tasks/filesystems/nfs.nix
  #   ##ntp ./services/networking/ntp/ntpd.nix
  #   pavucontrol
  #   pv
  #   ##squashfs-tools-ng ./tasks/filesystems/squashfs.nix
  #   wirelesstools
  #   bat
  #   espeakup
  #   gparted
  #   lsd
  #   orca
  #   wget
  #   which
  #   xclip
  #   zoxide
  ];
}
