{ pkgs, ... }:
let
  plasma-packages = with pkgs.libsForQt5; [
    bluez-qt
    discover
    dolphin
    elisa
    gwenview
    kate
    kcalc
    kde-gtk-config
    kdeconnect-kde
    kdeplasma-addons
    kfind
    kinfocenter
    kmenuedit
    kpipewire
    kscreen
    plasma-browser-integration
    plasma-desktop
    plasma-nm
    plasma-pa
    plasma-systemmonitor
    plasma-thunderbolt
    plasma-vault
    plasma-welcome
    plasma-workspace
    polkit-kde-agent
    spectacle
    systemsettings
  ];
in
{
  services = {
    xserver = {
      enable = true;
      desktopManager = {
        plasma5 = {
          enable = true;
          kwinrc = {
            "Plugins" = {
              blurEnabled = true;
              contrastEnabled = true;
              diminactiveEnabled = true;
              forceblurEnabled = true;
              invertEnabled = true;
              magiclampEnabled = true;
              slidebackEnabled = true;
              wobblywindowsEnabled = true;
            };
            "org.kde.kdecoration2" = {
              BorderSize = "None";
              BorderSizeAuto = false;
              ButtonsOnLeft = "XIA";
            };
          };
        };
      };
    };
  };
  environment.pathsToLink = [
    "/share/backgrounds" # TODO: https://github.com/NixOS/nixpkgs/issues/47173
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs.libsForQt5; [
      xdg-desktop-portal-kde
    ];
  };

  environment.systemPackages = plasma-packages;
}
