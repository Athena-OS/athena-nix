{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-green-base";
  version = "0-unstable-2024-07-13";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-green-base";
    rev = "2d74a76c6ac42efe3bbf20f12d7a3e3595618bfe";
    hash = "sha256-pBoX5rTPaXlCFojlfFhE37l4u9QMWQHBJAKEAyMTFko=";
  };

  installPhase = ''
    mkdir -p $out/share/{icons/hicolor/scalable/{apps,categories},backgrounds/athena}
    cp -r icons/apps/* $out/share/icons/hicolor/scalable/apps/
    cp -r icons/categories/* $out/share/icons/hicolor/scalable/categories/
    cp -r hackthebox.png $out/share/backgrounds/athena/
    cp -r nix-hackthebox.png $out/share/backgrounds/athena/
  '';

  meta = with lib; {
    description = "Green colorbase resources";
    homepage = "https://github.com/Athena-OS/athena-green-base";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
})
