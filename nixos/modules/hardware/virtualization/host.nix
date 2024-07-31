{ lib, config, ... }: {
  config = lib.mkIf config.athena.baseConfiguration {
    programs.virt-manager.enable = lib.mkDefault false;
    virtualisation = {
      /* QEMU - Virt Manager */
      libvirtd.enable = lib.mkDefault false;

      /*VMware Workstation software*/
      vmware.host = {
        enable = false;
        extraConfig = ''
          # Allow unsupported device's OpenGL and Vulkan acceleration for guest vGPU
          mks.gl.allowUnsupportedDrivers = "TRUE"
          mks.vk.allowUnsupportedDevices = "TRUE"
        '';
      };
    };
  };
}
