{
  imports = [
    ./bluetooth
    ./network
    ./sound
    ./virtualization
  ];

  services.xserver.libinput.enable = true;
}