{ pkgs, lib, home-manager, username, terminal, ... }:
let
  shellrocket = pkgs.writeShellScriptBin "shell-rocket" ''
    TERMINAL_EXEC="$TERMINAL -e"
    
    # Set fallback terminal if needed
    if [[ "$TERMINAL_EXEC" =~ "terminator" ]] || [[ "$TERMINAL_EXEC" =~ "terminology" ]] || [[ "$TERMINAL_EXEC" =~ "xfce4-terminal" ]]; then
      TERMINAL_EXEC="$TERMINAL -e"
    fi
    
    if [[ -n "$NO_REPETITION" ]]; then
      "$@"
    else
      NO_REPETITION=1 $TERMINAL_EXEC ${lib.getExe pkgs.bash} -c "$@"
    fi
  '';
in
{
  imports = [
    ./locale
  ];

  home-manager.users.${username} = { pkgs, ... }: {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "23.11";
    nixpkgs.config.allowUnfree = true;
  };

  environment.sessionVariables = {
    EDITOR = "nano";
    BROWSER = "firefox";
    TERMINAL = "${terminal}";
  };

  environment.systemPackages = with pkgs; [
    netcat-openbsd
    unzip
    tree
    git
    file
    lsd
    bat
    shellrocket
  ];

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
