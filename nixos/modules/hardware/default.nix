{
  imports = [
    ./bluetooth
    ./kernel
    ./network
    ./sound
    ./virtualization
  ];

  hardware.bolt.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
  services.xserver.libinput.enable = true;
}
