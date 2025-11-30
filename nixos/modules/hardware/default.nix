{ lib, config, ... }: {
  imports = [
    ./bluetooth
    ./kernel
    ./network
    ./sound
    ./virtualization
  ];

  config = lib.mkIf config.athena.baseConfiguration {
    # KDE complains if power management is disabled (to be precise, if
    # there is no power management backend such as upower).
    powerManagement = {
      enable = true;
      cpuFreqGovernor = "performance";
    };

    services = {
      hardware.bolt.enable = true;
      printing.enable = true;
      timesyncd.enable = true;
      libinput.enable = true;
      flatpak.enable = true;
    };
  
    boot.kernelParams = [ "kvm.enable_virt_at_load=0" ]; #Issue with KVM module
    
    zramSwap.enable = true;
    hardware = {
      cpu.intel.updateMicrocode = true;
      bluetooth.enable = true;
      #enableAllFirmware = true; # Need allowUnfree = true
      enableRedistributableFirmware = true;
      graphics = {
        enable = true;
      };
    };
  };
}
