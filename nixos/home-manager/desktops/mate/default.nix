{ lib, pkgs, config, ...}: let
  mate-packages = with pkgs.mate; [
    caja-with-extensions
    eom
    marco
    mate-control-center
    mate-desktop
    mate-media
    mate-netbook
    mate-panel
    mate-polkit
    mate-power-manager
    mate-session-manager
    mate-tweak
    mate-utils
  ];

  fontList = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  gtkTheme = "${config.athena.theme-components.gtk-theme}";
  gtkIconTheme = "${config.athena.theme-components.icon-theme}";
  gtkCursorTheme = "${config.athena.theme-components.cursor-theme}";
  backgroundTheme = "${config.athena.theme-components.background}";
in {
  config = lib.mkIf (config.athena.desktopManager == "mate") {
    # ---- System Configuration ----
    services.xserver = {
      enable = true;
      desktopManager.mate.enable = true;
    };

    xdg.portal.enable = true;
    environment = {
      pathsToLink = [ "/share/backgrounds" ]; # TODO: https://github.com/NixOS/nixpkgs/issues/47173
      systemPackages = mate-packages ++ [
        pkgs.xdg-user-dirs
      ];
    };

    # ---- Home Configuration ----
    home-manager.users.${config.athena.homeManagerUser} = { pkgs, ...}: {
      home.packages = fontList;
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "inode/directory" = ["caja.desktop"];
        };
      };

      dconf.settings = {
          "org/mate/desktop/interface" = {
              gtk-theme = gtkTheme;
              icon-theme = gtkIconTheme;
              color-scheme = "prefer-dark";
          };

          "org/mate/marco/general" = {
              theme = gtkTheme;
          };

          "org/mate/desktop/peripherals/mouse" = {
              cursor-theme = gtkCursorTheme;
          };

          "org/mate/desktop/background" = {
              picture-filename = "/run/current-system/sw/share/backgrounds/athena/"+backgroundTheme;
          };
      };

      # It copies "./config/menus/gnome-applications.menu" source file to the nix store, and then symlinks it to the location.
      xdg.configFile."menus/applications-merged/mate-applications.menu".source = ./config/menus/applications-merged/mate-applications.menu;

      dconf.settings = {
        "org/gnome/shell".favorite-apps = [ "athena-welcome.desktop" "athena-mimikatz.desktop" "athena-powersploit.desktop" "seclists.desktop" "payloadsallthethings.desktop" "powershell.desktop" "shell.desktop" "codium.desktop" "firefox-esr.desktop" "cyberchef.desktop" "fuzzdb.desktop" "securitywordlist.desktop" "autowordlists.desktop" ];

        # /desktop/applications/terminal
        "org/gnome/desktop/applications/terminal" = {
          exec = "${config.athena.terminal}";
        };

        # /panel
        "org/mate/panel/general" = {
          toplevel-id-list = ["top" "bottom"];
          object-id-list = [
            "menu-bar"
            "notification-area"
            "clock"
            "show-desktop"
            "window-list"
            "workspace-switcher"
            "object-0"
            "object-1"
            "object-2"
            "object-3"
            "object-4"
            "object-5"
            "object-6"
          ];
        };

        "org/mate/panel/objects/clock" = {
          applet-iid = "ClockAppletFactory::ClockApplet";
          locked = true;
          object-type = "applet";
          panel-right-stick = true;
          position = 0;
          toplevel-id = "top";
        };

        "org/mate/panel/objects/clock/prefs" = {
          format = "24-hour";
        };

        "org/mate/panel/objects/menu-bar" = {
          locked = true;
          object-type = "menu-bar";
          position = 0;
          toplevel-id = "top";
        };

        "org/mate/panel/objects/notification-area" = {
          applet-iid = "NotificationAreaAppletFactory::NotificationArea";
          locked = true;
          object-type = "applet";
          panel-right-stick = true;
          position = 10;
          toplevel-id = "top";
        };

        # "org/mate/panel/objects/object-0" = {
        #   launcher-location = "/run/current-system/sw/share/applications/cyberchef.desktop";
        #   object-type = "launcher";
        #   panel-right-stick = false;
        #   position = -1;
        #   toplevel-id = "top";
        # };

        # "org/mate/panel/objects/object-1" = {
        #   launcher-location = "/run/current-system/sw/share/applications/org.athenaos.CyberHub.desktop";
        #   object-type = "launcher";
        #   panel-right-stick = false;
        #   position = -1;
        #   toplevel-id = "top";
        # };

        "org/mate/panel/objects/object-0" = {
          launcher-location = "${pkgs.vscodium}/share/applications/codium.desktop";
          object-type = "launcher";
          panel-right-stick = false;
          position = -1;
          toplevel-id = "top";
        };

        "org/mate/panel/objects/object-1" = {
          launcher-location = "${pkgs.firefox-esr}/share/applications/firefox-esr.desktop";
          object-type = "launcher";
          panel-right-stick = false;
          position = -1;
          toplevel-id = "top";
        };

        "org/mate/panel/objects/object-2" = {
          launcher-location = "/run/current-system/sw/share/applications/powershell.desktop";
          object-type = "launcher";
          panel-right-stick = false;
          position = -1;
          toplevel-id = "top";
        };

        "org/mate/panel/objects/object-3" = {
          launcher-location = "/run/current-system/sw/share/applications/shell.desktop";
          object-type = "launcher";
          panel-right-stick = false;
          position = -1;
          toplevel-id = "top";
        };

        "org/mate/panel/objects/object-4" = {
          launcher-location = "/run/current-system/sw/share/applications/payloadsallthethings.desktop";
          object-type = "launcher";
          panel-right-stick = false;
          position = -1;
          toplevel-id = "top";
        };

        "org/mate/panel/objects/object-5" = {
          launcher-location = "/run/current-system/sw/share/applications/seclists.desktop";
          object-type = "launcher";
          panel-right-stick = false;
          position = -1;
          toplevel-id = "top";
        };

        "org/mate/panel/objects/object-6" = {
          launcher-location = "/run/current-system/sw/share/applications/athena-welcome.desktop";
          object-type = "launcher";
          panel-right-stick = false;
          position = -1;
          toplevel-id = "top";
        };

        "org/mate/panel/objects/show-desktop" = {
          applet-iid = "WnckletFactory::ShowDesktopApplet";
          locked = true;
          object-type = "applet";
          position = 0;
          toplevel-id = "bottom";
        };

        "org/mate/panel/objects/window-list" = {
          applet-iid = "WnckletFactory::WindowListApplet";
          locked = true;
          object-type = "applet";
          position = 20;
          toplevel-id = "bottom";
        };

        "org/mate/panel/objects/workspace-switcher" = {
          applet-iid = "WnckletFactory::WorkspaceSwitcherApplet";
          locked = true;
          object-type = "applet";
          panel-right-stick = true;
          position = 0;
          toplevel-id = "bottom";
        };

        "org/mate/panel/toplevels/bottom" = {
          expand = true;
          orientation = "bottom";
          screen = 0;
          size = 24;
          y = 854;
          y-bottom = 0;
        };

        "org/mate/panel/toplevels/top" = {
          expand = true;
          orientation = "top";
          screen = 0;
          size = 38;
        };
      };
    };
  };
}
