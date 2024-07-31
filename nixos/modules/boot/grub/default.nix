{ lib, config, ... }: {
  config = lib.mkIf (config.athena.bootloader == "grub") {
    # Bootloader
    boot.loader = {
      grub = {
        device = "/dev/sda";
        enableCryptodisk = true;
        configurationLimit = 5;
      };
    };
  };
}
