{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-blue-base";
  version = "0-unstable-2025-10-05";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-blue-base";
    rev = "b2623c3d7a1e5966511958eff8d4f491c2183a71";
    hash = "sha256-uDByU9EvaVQqZi8qe56K657fGbgidZEkpTH4WShRHsU=";
  };

  postPatch = ''
    substituteInPlace gnome-background-properties/*.xml \
      --replace-fail /usr/share/backgrounds $out/share/backgrounds
  '';

  installPhase = ''
    mkdir -p $out/share/{icons/hicolor/scalable/{apps,categories},backgrounds/athena,gnome-background-properties}
    cp -r icons/apps/* $out/share/icons/hicolor/scalable/apps/
    cp -r icons/categories/* $out/share/icons/hicolor/scalable/categories/
    cp -r wallpapers/arch-ascii.png $out/share/backgrounds/athena/
    cp -r wallpapers/nix-behind.png $out/share/backgrounds/athena/
    cp -r gnome-background-properties/arch-ascii.xml $out/share/gnome-background-properties/
    cp -r gnome-background-properties/nix-behind.xml $out/share/gnome-background-properties/
  '';

  meta = with lib; {
    description = "Blue colorbase resources";
    homepage = "https://github.com/Athena-OS/athena-blue-base";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
})
