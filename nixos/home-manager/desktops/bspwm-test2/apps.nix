{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      neofetch
      btop
      xfce.thunar
      pulsemixer
      polybar
      htop
      leafpad
      tdesktop
      flameshot
      qjackctl
      pavucontrol
      ardour
      cava
      ncmpcpp
    ];
  };
}
