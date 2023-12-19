{ pkgs, ... }:
{
  # ---- System Configuration ----
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable=true;
    #displayManager.lightdm.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  programs.dconf.enable = true;

  services.gnome = {
    gnome-keyring.enable = true;
  };

  #environment.systemPackages = with pkgs; [ nordic ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gnomeExtensions.fly-pie
    ]) ++ (with pkgs.gnome; [
    gnome-music
    gedit
    epiphany
    geary
    evince
    gnome-characters
    totem
    tali
    iagno
    hitori
    atomix
  ]);
}
