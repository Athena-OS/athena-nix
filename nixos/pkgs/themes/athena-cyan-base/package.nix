{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-cyan-base";
  version = "0-unstable-2025-10-27";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-cyan-base";
    rev = "907022436b406e74d758094939e9992873452671";
    hash = "sha256-E/k9+Lq/OWevRlyKLED1d3wumVwKSUVQd+Dyvvo3uv8=";
  };

  postPatch = ''
    substituteInPlace gnome-background-properties/*.xml \
      --replace-fail /usr/share/backgrounds $out/share/backgrounds
  '';  

  installPhase = ''
    mkdir -p $out/share/{icons/hicolor/scalable/{apps,categories},backgrounds/athena,gnome-background-properties}
    cp -r icons/apps/* $out/share/icons/hicolor/scalable/apps/
    cp -r icons/categories/* $out/share/icons/hicolor/scalable/categories/
    cp -r wallpapers/frost-daughter.png $out/share/backgrounds/athena/
    cp -r wallpapers/frost-daughter-tattoo.png $out/share/backgrounds/athena/
    cp -r wallpapers/nike.png $out/share/backgrounds/athena/
    cp -r wallpapers/nike-holo.png $out/share/backgrounds/athena/
    cp -r wallpapers/samurai-girl.png $out/share/backgrounds/athena/
    cp -r wallpapers/temple.png $out/share/backgrounds/athena/
    cp -r gnome-background-properties/frost-daughter.xml $out/share/gnome-background-properties/
    cp -r gnome-background-properties/nike.xml $out/share/gnome-background-properties/
    cp -r gnome-background-properties/nike-holo.xml $out/share/gnome-background-properties/
    cp -r gnome-background-properties/samurai-girl.xml $out/share/gnome-background-properties/
    cp -r gnome-background-properties/temple.xml $out/share/gnome-background-properties/
  '';

  meta = with lib; {
    description = "Cyan colorbase resources";
    homepage = "https://github.com/Athena-OS/athena-cyan-base";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
})
