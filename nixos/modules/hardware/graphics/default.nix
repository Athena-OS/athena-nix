{ lib, config, ... }: {
  config = lib.mkIf config.athena.baseConfiguration {
    hardware = {
      graphics = {
        enable = true;
      };
      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        prime = {
          sync.enable = true; 
          #offload.enable = true;
          #offload.enableOffloadCmd = true;
          # intelBusId = "PCI:0@0:2:0";
          # nvidiaBusId = "PCI:2@0:0:0";
          # amdgpuBusId = "PCI:5@0:0:0"; # If you have an AMD iGPU
        };
      };
    };
    services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  };
}
