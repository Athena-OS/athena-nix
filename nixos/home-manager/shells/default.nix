{ lib, config, ... }: {
  imports = [
    ./bash
    ./fish
    ./powershell
    ./zsh
  ];

  config = lib.mkIf config.athena.baseConfiguration {
    home-manager.users.${config.athena.homeManagerUser} = { pkgs, ...}: {
      home.file.".bash_aliases".source = ./bash_aliases;
      # home.packages = with pkgs; [
      #   neofetch
      #   zoxide
      # ];

      xdg.desktopEntries."shell" = {
        type = "Application";
        name = "Shell";
        comment = "Shell";
        icon = "shell";
        exec = "${config.athena.terminal}";
        terminal = false;
        categories = [ "Application" "Utility" ];
      };
    };
  };
}
