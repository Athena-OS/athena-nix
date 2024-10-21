{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-red-base";
  version = "0-unstable-2024-10-22";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-red-base";
    rev = "4c57cb32c328dfbeb9dc859d786ea0f80d0c7d8b";
    hash = "sha256-xVfVQEelgMw3vUi6RJsUBDPk/YVSfr3laUOMYxJ1st8=";
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
    cp -r wallpapers/murasame.jpg $out/share/backgrounds/athena/
    cp -r wallpapers/redmoon.png $out/share/backgrounds/athena/
    cp -r gnome-background-properties/akame.xml $out/share/gnome-background-properties/
    cp -r gnome-background-properties/murasame.xml $out/share/gnome-background-properties/
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
