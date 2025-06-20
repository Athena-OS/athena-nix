#!/usr/bin/env sh

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

invokeNixShell() {
    nix_cmd="$binary"
    if [[ -n "$args" ]]; then
      nix_cmd+=" $args"
    fi
    if [[ "$root" == true ]]; then
      nix_cmd="sudo $nix_cmd"
    fi
    if [[ "$guiapp" == true ]]; then
      nohup nix-shell -p "${pkg:-$binary}" --command "$nix_cmd; return" &
    else
      nix-shell -p "${pkg:-$binary}" --command "$nix_cmd; return"
    fi
    exit 0
}

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":b:c:d:ghp:rx:" option; do #When using getopts, putting : after an option character means that it requires an argument (i.e., 'i:' requires arg).
   case "$option" in
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

TERMINAL_EXEC="$TERMINAL -e"

# Set fallback terminal if needed
if [[ "$TERMINAL_EXEC" =~ "terminator" ]] || [[ "$TERMINAL_EXEC" =~ "terminology" ]] || [[ "$TERMINAL_EXEC" =~ "xfce4-terminal" ]]; then
  TERMINAL_EXEC="$TERMINAL -e"
fi

if [[ -z "$command" ]]; then
  # Search for application
  # If the tool is not installed, run it via Nix Shell
  if [ ! "$(command -v "$binary")" ] && [[ -z $directory ]]; then
    if [[ -n "$NO_REPETITION" ]]; then
      echo "$binary is not installed. Installing..."
      invokeNixShell
    else
      # Since here a new shell is invoked, launchViaNixShell must be re-defined
      NO_REPETITION=1 $TERMINAL_EXEC bash -c '
        launchViaNixShell() {
          nix_cmd="'$binary'"
          if [[ -n "'$args'" ]]; then
            nix_cmd+=" '$args'"
          fi
          if [[ "'$root'" == true ]]; then
            nix_cmd="sudo $nix_cmd"
          fi
          if [[ "'$guiapp'" == true ]]; then
            nohup nix-shell -p "'${pkg:-$binary}'" --command "$nix_cmd; return" &
          else
            nix-shell -p "'${pkg:-$binary}'" --command "$nix_cmd; return"
          fi
          exit 0
        }

        echo "'$binary' is not installed. Installing..."
        launchViaNixShell
      '
    fi
    exit 0
  fi

  # Running outside nix shell
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
      NO_REPETITION=1 $TERMINAL_EXEC bash -c "$binary;$SHELL"
    fi
  else
    if test -d "$directory"; then
      cd "$directory";$SHELL
    else
      sudo sed -i "s/#${pkg:-$binary}/${pkg:-$binary}/g" /etc/nixos/hosts/software/default.nix
      sudo nixos-rebuild switch
      cd "$directory";$SHELL
    fi 
  fi
else
    if [[ -n "$NO_REPETITION" ]]; then
    # Nix is trying to interpret the variable below as its own string interpolation syntax. To prevent this, needed to use an extra $
    "${command[@]}"
    else
      NO_REPETITION=1 $TERMINAL_EXEC bash -c "$command;$SHELL"
    fi
fi
