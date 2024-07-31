{ lib, config, ... }@inputs: let 
  cfg = config.athena-nix;
in {
  options = {
    athena-nix = {
      enable = lib.mkEnableOption "Enable athena-nix";
      baseConfiguration = lib.mkEnableOption "Enable base configuration";
      baseSoftware = lib.mkEnableOption "Enable base software";
      baseLocale = lib.mkEnableOption "Enable base locale";
      baseHosts = lib.mkEnableOption "Make base changes. Such as setting the stateVersion.";
      homeManagerUser = lib.mkOption {
        type = lib.types.str;
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
          "akame"
          "anunna"
          "cyborg"
          "graphite"
          "hackthebox"
          "samurai"
          "sweet"
          "temple"
        ];

        default = "graphite";
        description = ''
          The theme to use.
        '';
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
        type = with lib.types; nullOr (enum [ "gdm" "lightdm" ]);
        default = "lightdm";
        description = ''
          The display manager to use.
        '';
      };

      shell = lib.mkOption {
        type = with lib.types; nullOr (enum [
          "bash"
          "fish"
          "powershell"
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
        type = with lib.types; nullOr (enum [ "firefox" ]);
        default = "firefox";
        description = ''
          The browser to use.
        '';
      };
    };
  };

  config = lib.mkIf cfg.athena-nix.enable (let
    imports = lib.optionals cfg.baseConfiguration [
      ./home-manager
      ./modules
      ./pkgs
    ] ++ [ ./modules/themes/${cfg.theme} ]
    ++ (lib.optional (cfg.desktopManager != null) ./home-manager/desktops/${cfg.desktopManager})
    ++ lib.optional (cfg.displayManager != null) ./modules/dms/${cfg.displayManager}
    ++ lib.optional (cfg.shell != null) ./home-manager/shells/${cfg.shell}
    ++ lib.optional (cfg.terminal != null) ./home-manager/terminals/${cfg.terminal}
    ++ lib.optional (cfg.browser != null) ./home-manager/browsers/${cfg.browser}
    ++ lib.optional (cfg.bootloader != null) ./modules/boot/${cfg.bootloader}
    ++ lib.optional cfg.baseSoftware ./hosts/software
    ++ lib.optional cfg.baseLocale ./hosts/locale
    ++ lib.optional cfg.baseHosts ./hosts;
  in lib.mergeAttrsList (map (v: import v inputs) imports));
}

