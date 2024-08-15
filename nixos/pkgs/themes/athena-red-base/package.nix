{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-red-base";
  version = "0-unstable-2024-08-15";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-red-base";
    rev = "791c7a9fb0a240b792963e1723a5e45bc65e6bf6";
    hash = "sha256-7nQ007X+DjpFxmbr9Uxv7KIpSZn/Q3+H15i7M+5VBg0=";
  };

  postPatch = ''
    substituteInPlace gnome-background-properties/*.xml \
      --replace-fail /usr/share/backgrounds $out/share/backgrounds
  '';

  installPhase = ''
    mkdir -p $out/share/{icons/hicolor/scalable/{apps,categories},backgrounds/athena,gnome-background-properties}
    cp -r icons/apps/* $out/share/icons/hicolor/scalable/apps/
    cp -r icons/categories/* $out/share/icons/hicolor/scalable/categories/
    cp -r wallpapers/akame.jpg $out/share/backgrounds/athena/
    cp -r wallpapers/redmoon.png $out/share/backgrounds/athena/
    cp -r gnome-background-properties/akame.xml $out/share/gnome-background-properties/
    cp -r gnome-background-properties/redmoon.xml $out/share/gnome-background-properties/
  '';

  meta = with lib; {
    description = "Red colorbase resources";
    homepage = "https://github.com/Athena-OS/athena-red-base";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
})
