{ lib, config, pkgs, ... }: {
  config = lib.mkIf (config.athena.displayManager == "ly") {
    services.displayManager.ly = {
      enable = true;
      settings = {
          animate = true;
          animation = "matrix";
          animation_timeout_sec = 0;
          asterisk = "*";
          auth_fails = 10;
          battery_id = "null";
          auto_login_session = "null";
          auto_login_user = "null";
          bg = "0x00000000";
      };
    };
  };
}
