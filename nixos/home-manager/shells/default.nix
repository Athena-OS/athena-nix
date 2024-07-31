{ config, ... }: {
  imports = [
    ./powershell
  ];

  home-manager.users.${config.athena-nix.homeManagerUser} = { pkgs, ...}: {
    home.file.".bash_aliases".source = ./bash_aliases;
    #home.packages = with pkgs; [
    #  neofetch
    #  zoxide
    #];
    xdg.desktopEntries."shell" = {
      type = "Application";
      name = "Shell";
      comment = "Shell";
      icon = "shell";
      exec = "${config.athena-nix.terminal}";
      terminal = false;
      categories = [ "Application" "Utility" ];
    };
  };
}
