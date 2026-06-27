{ lib, config, ... }: {
  config = lib.mkIf config.athena.baseConfiguration {
    home-manager.users.${config.athena.homeManagerUser} = { pkgs, lib, config, ... }: {
      # It copies "./config/menus/xfce-applications.menu" source file to the nix store, and then symlinks it to the location.
      xdg.configFile."menus/blue-applications.menu".source = ./config/menus/blue-applications.menu;
      xdg.configFile."menus/red-applications.menu".source = ./config/menus/red-applications.menu;
      xdg.configFile."menus/mitre-applications.menu".source = ./config/menus/mitre-applications.menu;
      xdg.configFile."kando/config.json".source = ./config/kando/config.json;
      xdg.configFile."kando/menus.json".source = ./config/kando/menus.json;

      home.activation.kandoAthenaIcons =
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          iconThemesDir="${config.xdg.configHome}/kando/icon-themes"
          iconDir="$iconThemesDir/athena-theme"

          # Link the whole hicolor directory into icon-themes (structure preserved)
          run mkdir -p "$iconThemesDir"
          run ln -sfn /run/current-system/sw/share/icons/hicolor "$iconThemesDir/hicolor"

          # Link the pixmaps directory into icon-themes
          run ln -sfn /run/current-system/sw/share/pixmaps "$iconThemesDir/pixmaps"

          # Link the htb-toolkit directory into icon-themes
          run ln -sfn /run/current-system/sw/share/icons/htb-toolkit "$iconThemesDir/htb-toolkit"

          # Flatten category icons into athena-theme
          run rm -rf "$iconDir"
          run mkdir -p "$iconDir"
          shopt -s nullglob
          for f in \
            /run/current-system/sw/share/icons/hicolor/scalable/categories/* \
            /run/current-system/sw/share/icons/hicolor/scalable/apps/firefox-logo.svg \
            /run/current-system/sw/share/icons/hicolor/scalable/apps/terminal.svg \
            /run/current-system/sw/share/icons/hicolor/scalable/apps/vscode.svg; do
            run ln -sf "$f" "$iconDir/"
          done
        '';

      # Run Kando as a systemd user service instead of XDG autostart.
      systemd.user.services.kando = {
        Unit = {
          Description = "Kando pie menu";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.kando}/bin/kando";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      # Restart Kando on every switch, after icons are refreshed and systemd is reloaded.
      home.activation.restartKando =
        lib.hm.dag.entryAfter [ "kandoAthenaIcons" "reloadSystemd" ] ''
          run systemctl --user restart kando.service || true
        '';

      # Home Manager diffs and restarts changed user services on each switch.
      systemd.user.startServices = "sd-switch";
    };
  };
}
