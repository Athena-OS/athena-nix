{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-cyan-base";
  version = "0-unstable-2024-08-15";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-cyan-base";
    rev = "938493ccfad8868532c238e2e69c444bf075eb66";
    hash = "sha256-9IzEPVtsY8zb2yzM/14qw2TZ1X3KPq7YbfZg8T9kCZg=";
  };

  postPatch = ''
    substituteInPlace gnome-background-properties/*.xml \
      --replace-fail /usr/share/backgrounds $out/share/backgrounds
  '';  

  installPhase = ''
    mkdir -p $out/share/{icons/hicolor/scalable/{apps,categories},backgrounds/athena,gnome-background-properties}
    cp -r icons/apps/* $out/share/icons/hicolor/scalable/apps/
    cp -r icons/categories/* $out/share/icons/hicolor/scalable/categories/
    cp -r wallpapers/samurai-girl.jpg $out/share/backgrounds/athena/
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
