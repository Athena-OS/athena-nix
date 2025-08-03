{ config, pkgs, lib, ... }: with lib; let
  cfg = config.system.nixos;
  needsEscaping = s: null != builtins.match "[a-zA-Z0-9]+" s;
  escapeIfNecessary = s: if needsEscaping s then s else ''"${escape [ "\$" "\"" "\\" "\`" ] s}"'';
  attrsToText = attrs: concatStringsSep "\n" (
      mapAttrsToList (n: v: ''${n}=${escapeIfNecessary (toString v)}'') attrs
    ) + "\n";

  osReleaseContents = {
    NAME = "${cfg.distroName}";
    ID = "${cfg.distroId}";
    VERSION = "${cfg.release} (${cfg.codeName})";
    VERSION_CODENAME = toLower cfg.codeName;
    VERSION_ID = cfg.release;
    BUILD_ID = cfg.version;
    PRETTY_NAME = "${cfg.distroName} ${cfg.release} (${cfg.codeName})";
    LOGO = "nix-snowflake";
    HOME_URL = optionalString (cfg.distroId == "athena") "https://athenaos.org/";
    DOCUMENTATION_URL = optionalString (cfg.distroId == "athena") "https://athenaos.org/en/getting-started/athenaos/";
    SUPPORT_URL = optionalString (cfg.distroId == "athena") "https://athenaos.org/en/community/getting-help/";
    BUG_REPORT_URL = optionalString (cfg.distroId == "athena") "https://github.com/Athena-OS/athena-nix/issues";
  } // optionalAttrs (cfg.variant_id != null) {
    VARIANT_ID = cfg.variant_id;
  };

in {
  imports = [
    ./locale
    ./software
  ];

  config = mkIf (config.athena.baseConfiguration || config.athena.baseHosts) {
    programs = {
      git.enable = true;
      nano.enable = true;
      ssh.askPassword = ""; # Preventing OpenSSH popup during 'git push'
    };

    # It is needed to enable the used shell also at system level because NixOS cannot see home-manager modules. Note: bash does not need to be enabled
    programs.${config.athena.mainShell} = mkIf ("${config.athena.mainShell}" != "bash") {
      enable = true;
    };

    home-manager.users.${config.athena.homeManagerUser} = { pkgs, ... }: {
      /* The home.stateVersion option does not have a default and must be set */
      home.stateVersion = "25.11";
      nixpkgs.config.allowUnfree = true;
    };

    environment = {
      sessionVariables = {
        EDITOR = "nano";
        BROWSER = "${config.athena.browser}";
        SHELL = "/run/current-system/sw/bin/${config.athena.mainShell}";
        TERMINAL = "${config.athena.terminal}";
        TERM = "xterm-256color";
        NIXPKGS_ALLOW_UNFREE = "1"; # To allow nix-shell to use unfree packages
      };

      # Used mkForce to override/merge values in os-release. Needed because "text" attr is lib.types.lines type that is a mergeable type (so it appends values we assign to the attributes) mkForce prevents this appending because overwrites values.
      etc."os-release" = mkForce {
        text = attrsToText osReleaseContents;
      };
    };

    system.nixos = {
      distroName = "Athena OS Nix";
      distroId = "athenaos";
    };


    # ----- System Config -----
    # nix config
    nix = {
      package = pkgs.nixStable;
      settings = {
        allowed-users = ["@wheel"]; #locks down access to nix-daemon
        extra-experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = mkDefault true;

    # Dont change
    system.stateVersion = "25.11";
  };
}
