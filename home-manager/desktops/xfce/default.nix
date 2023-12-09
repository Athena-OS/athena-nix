{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.athena.desktops.xfce;
  genmon-cpu = pkgs.writeShellScriptBin "genmon-cpu"
    (builtins.readFile ./bin/genmon-cpu);
  genmon-datetime = pkgs.writeShellScriptBin "genmon-datetime"
    (builtins.readFile ./bin/genmon-datetime);
  genmon-mem = pkgs.writeShellScriptBin "genmon-mem"
    (builtins.readFile ./bin/genmon-mem);
  i3lock-everblush = pkgs.writeShellScriptBin "i3lock-everblush"
    (builtins.readFile ./bin/i3lock-everblush);
  xfce-init = pkgs.writeShellScriptBin "xfce-init"
    (builtins.readFile ./bin/xfce-init);
in
{
  options.athena.desktops.xfce = {
    enable = mkEnableOption (mdDoc "Whether to enable AthenaOS's XFCE desktop");
    picom = mkEnableOption (mdDoc "Whether to enable AthenaOS's XFCE desktop with Picom");
  };

  config = mkIf config.athena.desktops.xfce.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Cousine" "JetBrainsMono" "NerdFontsSymbolsOnly" ]; })
      #mugshot
      #xfce.xfce4-docklike-plugin
      findex # Highly customizable application finder written in Rust and uses Gtk3
      gnome.nautilus # The file manager for GNOME
      i3lock-color # A simple screen locker like slock, enhanced version with extra configuration options
      networkmanagerapplet # NetworkManager control applet for GNOME
      picom # A fork of XCompMgr, a sample compositing manager for X servers
      qt6Packages.qtstyleplugin-kvantum # SVG-based Qt theme engine plus a config tool and extra themes
      roboto # The Roboto family of fonts
      roboto-mono # Google Roboto Mono fonts
      xdg-user-dirs # A tool to help manage well known user directories like the desktop folder and the music folder
      xorg.xrandr
    ] ++ (with pkgs.xfce; [
      ristretto # A fast and lightweight picture-viewer for the Xfce desktop environment
      thunar # Xfce file manager
      xfce4-appfinder # Appfinder for the Xfce4 Desktop Environment
      xfce4-cpugraph-plugin # CPU graph show for Xfce panel
      xfce4-genmon-plugin # Generic monitor plugin for the Xfce panel
      xfce4-panel # Panel for the Xfce desktop environment
      xfce4-power-manager # A power manager for the Xfce Desktop Environment
      xfce4-pulseaudio-plugin # Adjust the audio volume of the PulseAudio sound system
      xfce4-screenshooter # Screenshot utility for the Xfce desktop
      xfce4-session # Session manager for Xfce
      xfce4-settings # Settings manager for Xfce
      xfce4-taskmanager # Easy to use task manager for Xfce
      xfce4-whiskermenu-plugin # Alternate application launcher for Xfce
      xfdesktop # Xfce's desktop manager
      xfwm4 # Window manager for Xfce
    ]) ++ [
      genmon-cpu
      genmon-datetime
      genmon-mem
      i3lock-everblush
      xfce-init
    ];
    programs.eww.enable = true;
    programs.eww.configDir = ./config/eww;
    qt.style.name = "qt5ct";

    xdg.configFile."picom/picom.conf".source = ./config/picom/picom.conf;
    xdg.configFile."neofetch/config.conf".source = ./config/neofetch/config.conf;
    xdg.configFile."xfce4".source = ./config/xfce4;
    xdg.configFile."gtk-3.0/gtk.css".source = ./config/gtk-3.0/gtk.css;
    xdg.configFile."Kvantum".source = ./config/Kvantum;
    xdg.dataFile."fonts/feather.ttf".source = ./fonts/feather.ttf;
    home.file.".themes".source = ./themes;


    systemd.user.services.picom = {
      Unit = {
        Description = "Picom X11 compositor";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        ExecStart = "${getExe pkgs.picom} --config ${config.xdg.configFile."picom/picom.conf".source}";
        Restart = "always";
        RestartSec = 3;
      };
    };
    xresources.properties = {
      # Thanks to https://github.com/Everblush
      "*background" = "#181f21";
      "*foreground" = "#dadada";
      # Black + DarkGrey
      "*color0" = "#22292b";
      "*color8" = "#3b4244";
      # DarkRed + Red
      "*color1" = "#e06e6e";
      "*color9" = "#ef7d7d";
      # DarkGreen + Green
      "*color2" = "#8ccf7e";
      "*color10" = "#9bdead";
      # DarkYellow + Yellow
      "*color3" = "#e5c76b";
      "*color11" = "#f4d67a";
      # DarkBlue + Blue
      "*color4" = "#67b0e8";
      "*color12" = "#6cb5ed";
      # DarkMagenta + Magenta
      "*color5" = "#c47fd5";
      "*color13" = "#ce89df";
      # DarkCyan + Cyan
      "*color6" = "#6da4cd";
      "*color14" = "#67cbe7";
      # LightGrey + White
      "*color7" = "#b3b9b8";
      "*color15" = "#bdc3c2";
    };
    xdg.desktopEntries."Findex" = {
      name = "Findex";
      comment = "Highly customizable application finder written in Rust and uses Gtk3";
      exec = "findex";
      terminal = false;
      categories = [ "Application" ];
    };
    xdg.desktopEntries."xfce-init" = {
      name = "XFCE Initialization";
      exec = "xfce-init";
      categories = [ "Application" ];
      noDisplay = true;
    };
    xdg.systemDirs.config = [ "/etc/xdg" "${config.xdg.configHome}/xfce4/xdg" ];
    home.sessionVariables = { QT_AUTO_SCREEN_SCALE_FACTOR = 0; };
    /*     xfconf.settings = {
      xfce4-session = {
      "startup/ssh-agent/enabled" = false;
      "general/LockCommand" = "${pkgs.lightdm}/bin/dm-tool lock";
      };
      xfce4-desktop = {
      "backdrop/screen0/monitorLVDS-1/workspace0/last-image" =
      "${pkgs.nixos-artwork.wallpapers.stripes-logo.gnomeFilePath}";
      };
      }; */
  };
}
