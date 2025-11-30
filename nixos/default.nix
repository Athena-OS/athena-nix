{ lib, config, ... }@inputs: let 
  cfg = config.athena;
in {
  options = {
    athena = {
      enable = lib.mkEnableOption "Enable Athena";
      baseConfiguration = lib.mkEnableOption "Enable base configuration";
      baseSoftware = lib.mkEnableOption "Enable base software";
      baseLocale = lib.mkEnableOption "Enable base locale";
      baseHosts = lib.mkEnableOption "Make base changes. Such as setting the stateVersion.";
      homeManagerUser = lib.mkOption {
        type = lib.types.str;
        default = "athena";
        description = ''
          The user to use for home-manager.
        '';
      };

      bootloader = lib.mkOption {
        type = with lib.types; nullOr (enum [ "grub" "systemd" ]);
        default = null;
        description = ''
          The bootloader to use.
        '';
      };

      theme = lib.mkOption {
        type = lib.types.enum [
          "anunna"
          "cyborg"
          "graphite"
          "hackthebox"
          "redmoon"
          "samurai"
          "sweet"
          "temple"
        ];

        default = "graphite";
        description = ''
          The design to use.
        '';
      };

      theme-components = lib.mkOption {
        type = lib.types.attrs;
        description = "The components of the theme to use. Internal use.";
        visible = false;
      };

      desktopManager = lib.mkOption {
        type = with lib.types; nullOr (enum [
          "axyl"
          "bspwn"
          "bspwn-critical"
          "cinnamon"
          "gnome"
          "kde"
          "mate"
          "xfce"
        ]);

        default = "mate";
        description = ''
          The desktop manager to use.
        '';
      };

      displayManager = lib.mkOption {
        type = with lib.types; nullOr (enum [ "gdm" "lightdm" "sddm" ]);
        default = "sddm";
        description = ''
          The display manager to use.
        '';
      };

      mainShell = lib.mkOption {
        type = with lib.types; nullOr (enum [
          "bash"
          "fish"
          "zsh"
        ]);

        default = "bash";
        description = ''
          The shell to use.
        '';
      };

      terminal = lib.mkOption {
        type = with lib.types; nullOr (enum [
          "alacritty"
          "kitty"
        ]);

        default = "alacritty";
        description = ''
          The terminal to use.
        '';
      };

      browser = lib.mkOption {
        type = with lib.types; nullOr (enum [ 
	  "firefox"
	  "brave" ]);
        default = "firefox";
        description = ''
          The browser to use.
        '';
      };
    };
  };

  imports = [
    ./home-manager
    ./modules
    ./pkgs
    ./modules/design
    ./home-manager/desktops
    ./modules/dms
    ./home-manager/shells
    ./home-manager/terminals
    ./home-manager/browsers
    ./modules/boot
    ./hosts
  ];
}

