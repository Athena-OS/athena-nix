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

  shellrocket = pkgs.writeShellScriptBin "shell-rocket" ''
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "$(basename "$0") [-b <binary>] [-c <command>] [-d <directory>] [-g] [-h] [-p <package>] [-r] [-x <args>]"
   echo
   echo "Options:"
   echo "-b     Specify the binary to launch."
   echo "-c     Specify the command to launch."
   echo "-d     Specify the directory to land."
   echo "-g     Set if launching a GUI application."
   echo "-h     Print this Help."
   echo "-p     Specify the binary package."
   echo "-r     Run as root."
   echo "-x     Specify additional arguments to pass to the binary."
   echo
   echo "Usage Examples:"
   echo "$(basename "$0") -b burpsuite -g"
   echo "$(basename "$0") -b msfconsole -p metasploit"
   echo "$(basename "$0") -b nmap"
   echo "$(basename "$0") -b seclists -d /usr/share/payloads/seclists"
   echo "$(basename "$0") -c \"echo \"Disconnecting all VPN sessions...\";sudo killall openvpn\""
   echo
}

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":b:c:d:ghp:rx:" option; do #When using getopts, putting : after an option character means that it requires an argument (i.e., 'i:' requires arg).
   case "${option}" in
      b) 
         binary=$OPTARG
         ;;
      c)
         command=$OPTARG
         ;;
      d)
         directory=$OPTARG
         ;;
      g)
         guiapp=true
         ;;
      h) # display Help
         Help >&2
         exit 0
         ;;
      p) 
         pkg=$OPTARG
         ;;
      r) 
         root=true
         ;;
      x) 
         args=$OPTARG
         ;;
      : )
        echo "Missing option argument for -$OPTARG" >&2; exit 0;;
      #*  )
        #echo "Unimplemented option: -$OPTARG" >&2; exit 0;;
     \?) # Invalid option
         echo "Error: Invalid option" >&2
         ;;
   esac
done

if [ $# -eq 0 ]; then
    echo "Error: no arguments provided."
    echo
    Help >&2
    exit 0
fi

temp_file=$(mktemp)
TERMINAL_EXEC="alacritty -e"

# Set fallback terminal if needed
if [[ "$TERMINAL_EXEC" =~ "terminator" || "$TERMINAL_EXEC" =~ "terminology" || "$TERMINAL_EXEC" =~ "xfce4-terminal" ]]; then
  TERMINAL_EXEC="alacritty -e"
fi

if [[ -z "$command" ]]; then
  # Search for application
  if [ ! "$(command -v "$binary")" ] && [[ ! -d $directory ]]; then
    if [ -n "$pkg" ]; then
      if [[ -n "$NO_REPETITION" ]]; then
        echo "$binary is not installed. Installing..."
        sudo pacman -S "$pkg"
      else
        NO_REPETITION=1 $TERMINAL_EXEC /usr/bin/bash -c "echo \"$binary is not installed. Installing...\" && sudo pacman -S $pkg |& tee $temp_file;if grep -q "error:" "$temp_file"; then $SHELL;fi"
      fi
    else
      if [[ -n "$NO_REPETITION" ]]; then
        echo "$binary is not installed. Installing..."
        sudo pacman -S "$binary"
      else
        NO_REPETITION=1 $TERMINAL_EXEC /usr/bin/bash -c "echo \"$binary is not installed. Installing...\" && sudo pacman -S $binary |& tee $temp_file;if grep -q "error:" "$temp_file"; then $SHELL;fi"
      fi
    fi

    install_output=$(<"$temp_file")
    rm "$temp_file"
    # Check the output of the installation command for any error messages indicating a failure
    # Message printed on the calling terminal, not on the invoked one
    if echo "$install_output" | grep -q "error:"; then
        echo "Failed to install $binary. $binary package not found. Check if the binary has a different package name and use -p argument to specify it."
        exit 1
    fi
  fi

  if [[ "$root" ]] && [[ ! "$guiapp" ]]; then
    binary="echo '$binary requires root permission...';sudo $binary"
  elif [[ "$root" ]] && [[ "$guiapp" ]]; then
    binary=(pkexec "$binary")
  fi

  if [[ -n "$args" ]]; then
    binary+=" $args"
  fi

  if [[ -z "$directory" ]]; then
    if [[ -n "$NO_REPETITION" ]] || [[ "$guiapp" ]]; then
      "${binary[@]}"
    else
      NO_REPETITION=1 $TERMINAL_EXEC /usr/bin/bash -c "$binary;$SHELL"
    fi
  else
    if [[ -n "$NO_REPETITION" ]]; then
      cd $directory;$SHELL
    else
      NO_REPETITION=1 $TERMINAL_EXEC /usr/bin/bash -c "cd $directory;$SHELL"
    fi
  fi
else
    if [[ -n "$NO_REPETITION" ]]; then
      "${command[@]}"
    else
      NO_REPETITION=1 $TERMINAL_EXEC /usr/bin/bash -c "$command;$SHELL"
    fi
fi
  '';
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
      home.stateVersion = "24.05";
      nixpkgs.config.allowUnfree = true;
    };

    environment = {
      systemPackages = [ shellrocket ];
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
      distroName = "Athena OS";
      distroId = "athena";
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
    system.stateVersion = "24.05";
  };
}
