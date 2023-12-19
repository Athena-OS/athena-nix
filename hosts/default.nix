{ pkgs, home-manager, username, ... }:
{
  imports = [
    ./locale
  ];

  home-manager.users.${username} = { pkgs, ... }: {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "23.11";
    nixpkgs.config.allowUnfree = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # ----- System Config -----
  # Enable Flakes and nix-commands
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
          
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
   
  # Dont change.
  system.stateVersion = "23.11"; # Did you read the comment?

}
