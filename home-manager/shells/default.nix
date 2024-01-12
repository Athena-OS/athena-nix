{ home-manager, username, terminal, ... }:
{
    home-manager.users.${username} = { pkgs, ...}: {
      xdg.desktopEntries."shell" = {
        type = "Application";
        name = "Shell";
        comment = "Shell";
        icon = "shell";
        exec = "${terminal}";
        terminal = false;
        categories = [ "Application" "Utility" ];
      };
    };
}