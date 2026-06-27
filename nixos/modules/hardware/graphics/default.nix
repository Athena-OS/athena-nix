{ lib, config, ... }: {
  config = lib.mkIf config.athena.baseConfiguration {
    hardware = {
      graphics = {
        enable = true;
      };
      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        #prime = {
          #offload.enable = true;
          #offload.enableOffloadCmd = true;
          #intelBusId = "PCI:0:2:0"; -> run lspci | grep -E 'VGA|3D' to get the PCI ID of Intel
          #nvidiaBusId = "PCI:1:0:0"; -> run lspci | grep -E 'VGA|3D' to get the PCI ID of Nvidia
        #};
      };
    };
    services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  };
}
