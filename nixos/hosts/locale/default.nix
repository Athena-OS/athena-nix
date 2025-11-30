{ lib, config, pkgs, ... }: {
  config = lib.mkIf config.athena.baseLocale {
    # Set your time zone.
    time.timeZone = "US/Eastern";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    console = {
      earlySetup = true;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-v24n.psf.gz";
      packages = with pkgs; [ terminus_font ];
      keyMap = "us";
    };

    # Configure keymap in X11
    services.xserver = {
      exportConfiguration = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };
}
