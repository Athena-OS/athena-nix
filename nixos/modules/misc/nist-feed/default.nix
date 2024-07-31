{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.nist-feed;
  nistFeedPkg = pkgs.callPackage ../../../pkgs/nist-feed/package.nix { };
in {
  options = {
    services.nist-feed = {
      enable = mkEnableOption (lib.mdDoc "NIST Feed notifies you about the newest published CVEs according your filters. Keep updated with the latest CVEs according your preferences!");
      arguments = mkOption {
        type = types.str;
        default = "-l -s CRITICAL";
      };
    };
  };

  config = lib.mkIf (config.athena.baseConfiguration && cfg.enable) {
    systemd.user = {
      services.nist-feed = {
        wantedBy = [ "default.target" ];
        description = "NIST-Feed notifies you about the newest published CVEs according your filters. Keep updated with the latest CVEs according your preferences!";
        path = [ pkgs.curl pkgs.busybox ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${nistFeedPkg}/bin/nist-feed ${cfg.arguments}";
        };
      };

      timers.nist-feed = {
        wantedBy = [ "default.target" ];
        description = "NIST-Feed timer";
        timerConfig = {
          Unit = "nist-feed.service";
          OnCalendar = "*:0/30";
          Persistent = "true";
        };
      };
    };
  };
}
