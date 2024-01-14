{ pkgs, ... }:
{

  # ---- System Configuration ----
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable=true;
  };

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  programs.dconf.enable = true;

  services.gnome = {
    evolution-data-server.enable = true;
    gnome-keyring.enable = true;
  };

  gtk.iconCache.enable = true;

  environment.systemPackages = with pkgs; [ gnome.eog gnome.gnome-tweaks ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    ]) ++ (with pkgs.gnome; [
    gnome-music
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
