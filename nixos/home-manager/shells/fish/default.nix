{ lib, config, ... }: {
  config = lib.mkIf (config.athena.mainShell == "fish") {
    home-manager.users.${config.athena.homeManagerUser} = { pkgs, ...}: {
      home.packages = with pkgs; [
        fastfetch
        zoxide
      ];

      programs.fish = {
        enable = true;
	functions = {
          fish_prompt.body = ''
            function fish_prompt
                set -l last_status $status
                set -l ip (ip -4 addr | grep -v '127.0.0.1' | grep -v 'secondary' | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | sed -z 's/\n/|/g;s/|\$/\n/' | rev | cut -c 2- | rev)
                set -l user (whoami)
                set -l host (prompt_hostname)
                set -l cwd (pwd)
                set -l branch
                set -l hq_prefix
                set -l flame
                set -l robot
            
                if type -q git
                    set branch (git symbolic-ref --short HEAD 2>/dev/null)
                end
            
                set -l use_emoji 1
                if string match -q '/dev/tty*' (tty)
                    set use_emoji 0
                end
            
                # Emojis only if not in TTY
                if test $use_emoji -eq 1
                    set hq_prefix "HQ🚀🌐"
                    set flame "🔥"
                    set robot "[👾]"
                else
                    set hq_prefix "HQ─"
                    set flame ""
                    set robot "[>]"
                end
            
                # First line
                set_color 00ff00
                echo -n "╭─[$hq_prefix"
                set_color red
                echo -n "$ip"
                set_color 00ff00
                echo -n "$flame]─("
            
                if test $last_status -eq 0
                    set_color blue
                else
                    set_color red
                end
                echo -n "$user@$host"
                set_color 00ff00
                echo -n ")"
            
                if test -n "$branch"
                    set_color yellow
                    echo -n "[ $branch]"
                end
            
                echo
            
                # Second line
                set_color 00ff00
                echo -n "╰─>$robot"
                set_color 00ffff
                echo -n "$cwd"
                echo -n ' $ '
                set_color normal
            end
          '';
        };

        interactiveShellInit = ''
          set -U fish_greeting ""

          source ~/.bash_aliases

          zoxide init fish | source

          set -g fish_color_autosuggestion 848cb5

          #set -x BFETCH_INFO "pfetch"
          #set -x BFETCH_ART "$HOME/.local/textart/fetch/unix.textart"
          #set -x PF_INFO "Unix Genius"

          #set -x BFETCH_INFO "curl --silent --location 'wttr.in/rome?0pq'"
          #set -x BFETCH_ART "printf \"\033[35m\"; figlet -f Bloody Spooky"
          #set -x BFETCH_COLOR "$HOME/.local/textart/color/icon/ghosts.textart"

          #set -x BFETCH_INFO "exa -la"
          #set -x BFETCH_ART "$HOME/.local/textart/fetch/pacman-maze.textart"
          #set -x BFETCH_COLOR "$HOME/.local/textart/color/icon/pacman.textart"

          set -x BFETCH_INFO "pfetch"
          set -x BFETCH_ART "cowsay '<3 Athena OS'"
          set -x BFETCH_COLOR "$HOME/.local/textart/color/icon/panes.textart"

          set -x PAYLOADS "/run/current-system/sw/share/wordlists"
          set -x SECLISTS "$PAYLOADS/seclists"
          set -x PAYLOADSALLTHETHINGS "$PAYLOADS/PayloadsAllTheThings"
          set -x FUZZDB "$PAYLOADS/FuzzDB"
          set -x AUTOWORDLISTS "$PAYLOADS/Auto_Wordlists"
          set -x SECURITYWORDLIST "$PAYLOADS/Security-Wordlist"

          set -x MIMIKATZ "/run/current-system/sw/share/mimikatz/"
          set -x POWERSPLOIT "/run/current-system/sw/share/powersploit/"

          set -x ROCKYOU "$SECLISTS/Passwords/Leaked-Databases/rockyou.txt"
          set -x DIRSMALL "$SECLISTS/Discovery/Web-Content/directory-list-2.3-small.txt"
          set -x DIRMEDIUM "$SECLISTS/Discovery/Web-Content/directory-list-2.3-medium.txt"
          set -x DIRBIG "$SECLISTS/Discovery/Web-Content/directory-list-2.3-big.txt"
          set -x WEBAPI_COMMON "$SECLISTS/Discovery/Web-Content/api/api-endpoints.txt"
          set -x WEBAPI_MAZEN "$SECLISTS/Discovery/Web-Content/common-api-endpoints-mazen160.txt"
          set -x WEBCOMMON "$SECLISTS/Discovery/Web-Content/common.txt"
          set -x WEBPARAM "$SECLISTS/Discovery/Web-Content/burp-parameter-names.txt"

          set -gx TERM xterm-256color
          if status is-interactive
              # Commands to run in interactive sessions can go here
              if not set -q NO_REPETITION
                  fastfetch
              end
          end
        '';
      };
    };
  };
}
