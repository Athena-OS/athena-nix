{ pkgs, ... }:
{
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
}
