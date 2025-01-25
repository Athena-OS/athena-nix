{ lib, config, pkgs, ... }: {
  config = lib.mkIf (config.athena.displayManager == "sddm") {
    services.displayManager.sddm = {
      package = pkgs.kdePackages.sddm;
      enable = true;
      theme = "sddm-astronaut-theme";
      wayland.enable = true;
      extraPackages = with pkgs; [
        kdePackages.qtsvg
        kdePackages.qtmultimedia
        kdePackages.qtvirtualkeyboard
      ];
    };
    environment.systemPackages = with pkgs; [
      (sddm-astronaut.override {
        embeddedTheme = "cyberpunk";
      })
    ];
  };
}
