{
  imports = [
    ./bluetooth
    ./kernel
    ./network
    ./sound
    ./virtualization
  ];

  powerManagement.cpuFreqGovernor = "performance";
  services.xserver.libinput.enable = true;
}
