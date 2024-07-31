{ lib, pkgs, config, ... }: {
  config = lib.mkIf config.athena.baseConfiguration {
    # If change kernel, remember to run 'sudo nixos-rebuild boot' and 'sudo reboot'
    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxPackages; # LTS Kernel
      kernelModules = [ "rtl8821cu" ];
      loader.grub.useOSProber = true;
      extraModulePackages = with config.boot.kernelPackages; [ vmware ]; /*vmware needed to install VMware Workstation software*/
    };
  };
}
