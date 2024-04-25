{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-red-base";
  version = "0-unstable-2024-02-10";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-red-base";
    rev = "1e26aa7ed53eb0b524dc2ee4cae6bea87a44aaf6";
    hash = "sha256-MY/AHuYqznmxwdK2BcHYfoi0EgrHOFYyLf9UcJGzRdA=";
  };

  installPhase = ''
    mkdir -p $out/share/{icons/hicolor/scalable/{apps,categories},backgrounds/athena}
    cp -r icons/apps/* $out/share/icons/hicolor/scalable/apps/
    cp -r icons/categories/* $out/share/icons/hicolor/scalable/categories/
    cp -r akame.jpg $out/share/backgrounds/athena/
    cp -r redmoon.png $out/share/backgrounds/athena/
  '';

  meta = with lib; {
    description = "Red colorbase resources";
    homepage = "https://github.com/Athena-OS/athena-red-base";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
})