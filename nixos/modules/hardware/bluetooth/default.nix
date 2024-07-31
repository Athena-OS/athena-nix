{ lib, config, ... }: {
  config = lib.mkIf config.athena.baseConfiguration {
    # Bluetooth
    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true; # enables support for Bluetooth
      powerOnBoot = true; # powers up the default Bluetooth controller on boot
    };
  };
}
