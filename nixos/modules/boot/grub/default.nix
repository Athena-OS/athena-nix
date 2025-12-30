{ lib, config, ... }: {
  config = lib.mkIf (config.athena.bootloader == "grub") {
    # Bootloader
    boot.loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
        enableCryptodisk = true;
        configurationLimit = 5;
      };
    };
  };
}
