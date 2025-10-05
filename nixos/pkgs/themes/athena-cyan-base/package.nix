{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-cyan-base";
  version = "0-unstable-2025-10-05";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-cyan-base";
    rev = "64d08ea34e91376b743b5957fda799485b46cbfd";
    hash = "sha256-37TR4abPjONYHFQlw/avAopoea5OzbIUo2+ZOoOF6Hc=";
  };

  postPatch = ''
    substituteInPlace gnome-background-properties/*.xml \
      --replace-fail /usr/share/backgrounds $out/share/backgrounds
  '';  

  installPhase = ''
    mkdir -p $out/share/{icons/hicolor/scalable/{apps,categories},backgrounds/athena,gnome-background-properties}
    cp -r icons/apps/* $out/share/icons/hicolor/scalable/apps/
    cp -r icons/categories/* $out/share/icons/hicolor/scalable/categories/
    cp -r wallpapers/samurai-girl.png $out/share/backgrounds/athena/
    cp -r wallpapers/temple.png $out/share/backgrounds/athena/
    cp -r wallpapers/nike.png $out/share/backgrounds/athena/
    cp -r wallpapers/nike-holo.png $out/share/backgrounds/athena/
    cp -r gnome-background-properties/samurai-girl.xml $out/share/gnome-background-properties/
    cp -r gnome-background-properties/temple.xml $out/share/gnome-background-properties/
    cp -r gnome-background-properties/nike.xml $out/share/gnome-background-properties/
    cp -r gnome-background-properties/nike-holo.xml $out/share/gnome-background-properties/
  '';

  meta = with lib; {
    description = "Cyan colorbase resources";
    homepage = "https://github.com/Athena-OS/athena-cyan-base";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
})
