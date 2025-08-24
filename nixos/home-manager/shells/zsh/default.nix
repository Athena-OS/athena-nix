{ lib, pkgs, config, ... }:
with lib;
let
  shopt = pkgs.writeShellScriptBin "shopt" (builtins.readFile ./shopt);
in {
  config = mkIf (config.athena.mainShell == "zsh") {
    # System-level packages so their .zsh files are available
    environment.systemPackages = with pkgs; [
      nix-zsh-completions
      zsh-autosuggestions
      zsh-syntax-highlighting
    ];

    home-manager.users.${config.athena.homeManagerUser} = { pkgs, config, ...}: {
      home.packages = with pkgs; [
        fastfetch
        shopt
      ];

      programs.zsh = {
        enable = true;

        # ---------- History ----------
        history = {
          path = "${config.home.homeDirectory}/.zsh_history";
          size = 10000;   # HISTSIZE
          save = 1000;    # SAVEHIST
          expireDuplicatesFirst = true;
        };

        # ---------- Options ----------
        setOptions = [
          "INC_APPEND_HISTORY"
        ];

        # ---------- Completions & zplug ----------
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        zplug = {
          enable = true;
          plugins = [
            { name = "zsh-users/zsh-autosuggestions"; }
            { name = "zsh-users/zsh-history-substring-search"; }
            { name = "zsh-users/zsh-syntax-highlighting"; }
            # { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Uncomment to use powerlevel10k plugin
          ];
        };

        # ---------- Aliases ----------
        shellAliases = {
          shopt = "/run/current-system/sw/bin/shopt";
          # ll = "ls -l";
          # update = "sudo nixos-rebuild switch";
        };

        # ---------- What compinit adds (kept from your file) ----------
        completionInit = ''
          # The following lines were added by compinstall
          zstyle :compinstall filename "$HOME/.zshrc"
          autoload -U +X bashcompinit && bashcompinit
          autoload -U +X compinit && compinit
          # End of lines added by compinstall
        '';

        # ---------- Content init after completion ----------
        initContent = ''
          # Emacs-style keymap
          bindkey -e

          # Keybindings
          bindkey "^[[1;5C" forward-word
          bindkey "^[[1;5D" backward-word
          bindkey "\e[1~" beginning-of-line
          bindkey "\e[4~" end-of-line
          bindkey "\e[5~" beginning-of-history
          bindkey "\e[6~" end-of-history
          bindkey "\e[7~" beginning-of-line
          bindkey "\e[3~" delete-char
          bindkey "\e[2~" quoted-insert
          bindkey "\e[5C" forward-word
          bindkey "\e[5D" backward-word
          bindkey "\e\e[C" forward-word
          bindkey "\e\e[D" backward-word
          bindkey "\e[1;5C" forward-word
          bindkey "\e[1;5D" backward-word
          bindkey "\e[8~" end-of-line
          bindkey "\eOH" beginning-of-line
          bindkey "\eOF" end-of-line
          bindkey "\e[H" beginning-of-line
          bindkey "\e[F" end-of-line

          # Things you wanted once per interactive shell start
          source ~/.bash_aliases 2>/dev/null || true
          fastfetch || true

        # ---------- Prompt & precmd hook ----------
          function build_prompt() {
            local last_status=$?
            local tty_device=$(tty)
            local ip=$(ip -4 addr | grep -v '127.0.0.1' | grep -v 'secondary' \
              | grep -oP '(?<=inet\s)\d+(\.\d+){3}' \
              | sed -z 's/\n/|/g;s/|\$/\n/' \
              | rev | cut -c 2- | rev)

            local user="%n"
            local host="%m"
            local cwd="%~"
            local branch=""
            local hq_prefix=""
            local flame=""
            local robot=""

            # Git branch detection
            if command -v git &>/dev/null; then
              branch=$(git symbolic-ref --short HEAD 2>/dev/null)
            fi

            # Emoji mode detection
            if [[ "$tty_device" == /dev/tty* ]]; then
              hq_prefix="HQ─"
              flame=""
              robot="[>]"
            else
              hq_prefix="HQ🚀🌐"
              flame="🔥"
              robot="[👾]"
            fi

            # Color for user@host based on last status
            local user_host
            if [[ $last_status -eq 0 ]]; then
              user_host="%F{blue}($user@$host)%f"
            else
              user_host="%F{red}($user@$host)%f"
            fi

            # First line
            local line1="%F{46}╭─[$hq_prefix%F{196}$ip%F{46}$flame]─$user_host"
            if [[ -n "$branch" ]]; then
              line1+="%F{220}[ $branch]%f"
            fi

            # Second line
            local line2="%F{46}╰─>$robot%F{44}$cwd $%f"

            PROMPT="$line1"$'\n'"$line2 "
          }

          autoload -Uz add-zsh-hook
          add-zsh-hook precmd build_prompt
        '';
      };
    };
  };
}
