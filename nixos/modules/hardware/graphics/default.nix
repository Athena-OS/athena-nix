{ lib, config, ... }: {
  config = lib.mkIf config.athena.baseConfiguration {
    hardware = {
      graphics = {
        enable = true;
      };
      nvidia = {
        modesetting.enable = false;
        powerManagement.enable = false;
        open = false;
        nvidiaSettings = false;
        #package = config.boot.kernelPackages.nvidiaPackages.stable;
        prime.sync.enable = false;
        #prime = {
          #offload.enable = true;
          #offload.enableOffloadCmd = true;
          # intelBusId = "PCI:0@0:2:0";
          # nvidiaBusId = "PCI:2@0:0:0";
          # amdgpuBusId = "PCI:5@0:0:0";
        #};
      };
    };
    #services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  };
}
