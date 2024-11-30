{ lib, pkgs, config, ... }:
let
  fontList = with pkgs; [
    noto-fonts-emoji
    dejavu_fonts
    liberation_ttf
    source-code-pro
    inter
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    nerd-fonts.iosevka
  ];

  bspwm-packages = with pkgs; [
    alacritty
    bat
    bluez
    bluez-tools
    brightnessctl
    btop
    dunst
    feh
    ffcast
    ffmpegthumbnailer
    geany
    glfw-wayland
    gnome.libgnome-keyring
    i3lock-color
    imagemagick
    jq
    libwebp
    lsd
    maim
    mlocate
    mpc-cli
    ncmpcpp
    nettools
    openvpn
    pamixer
    papirus-icon-theme
    pavucontrol
    physlock
    playerctl
    polkit_gnome
    polybar
    powerline
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtsvg
    libsForQt5.qt5.qtwayland
    ranger
    rofi
    scrot
    sxhkd
    tdrop
    ueberzug
    vim
    vimPlugins.vim-airline
    vimPlugins.vim-airline-themes
    vimPlugins.Vundle-vim
    webp-pixbuf-loader
    xclip
    xdg-user-dirs
    xdotool
    xorg.xinit
    xorg.xkill
    xorg.xlsclients
    xorg.xprop
    xorg.xrandr
    xorg.xsetroot
    xorg.xwininfo
    xwayland
    zoxide
    zsh-powerlevel10k
  ];
in {
  config = lib.mkIf (config.athena.desktopManager == "axyl") {
    # ---- System Configuration ----
    environment.systemPackages = bspwm-packages ++ fontList;
    services = {
      xserver = {
        enable = true;
        windowManager = {
          bspwm.enable = true;
        };
      };

      picom = {
        enable = true;
        settings = import ./picom.nix;
      };
    };

    # ---- Home Configuration ----
    home-manager.users.${config.athena.homeManagerUser} = { pkgs, ...}: {
      programs.alacritty = {
        enable = true;
        settings = import ./alacritty.nix;
      };

      services = {
        dunst = {
          enable = true;
          settings = import ./dunst.nix;
        };

        polybar = {
          enable = true;
          script = "";
        };

        sxhkd = {
          enable = true;
          keybindings = import ./sxhkd.nix;
        };
      };

      # It copies "./config/menus/gnome-applications.menu" source file to the nix store, and then symlinks it to the location.
      xdg.configFile = {
        "bspwm/bspwmrc".source = ./bspwmrc;
        "bspwm/.fehbg".source = ./.fehbg;
        "bspwm/wallpaper.jpg".source = ./wallpaper.jpg;
        "bspwm/polybar/colors".source = ./polybar/colors;
        "bspwm/polybar/config".source = ./polybar/config;
        "bspwm/polybar/decor".source = ./polybar/decor;
        "bspwm/polybar/modules".source = ./polybar/modules;
        "bspwm/polybar/system".source = ./polybar/system;
        "bspwm/polybar/launch.sh".source = ./polybar/launch.sh;
        "bspwm/scripts".source = ./scripts;
        "bspwm/assets".source = ./assets;
        "rofi".source = ./rofi;
      };
    };
  };
}
