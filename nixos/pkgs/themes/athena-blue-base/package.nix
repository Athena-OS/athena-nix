{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-blue-base";
  version = "0-unstable-2024-04-25";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-blue-base";
    rev = "f0741badc21bbc52eb06c19944179b91a71fa437";
    hash = "sha256-kqPR9LfrBGsP4SF64D43cr8oHOpFeFG2v+vXm1ShMmA=";
  };

  installPhase = ''
    mkdir -p $out/share/{icons/hicolor/scalable/{apps,categories},backgrounds/athena}
    cp -r icons/apps/* $out/share/icons/hicolor/scalable/apps/
    cp -r icons/categories/* $out/share/icons/hicolor/scalable/categories/
    cp -r nix-behind.png $out/share/backgrounds/athena/
  '';

  meta = with lib; {
    description = "Blue colorbase resources";
    homepage = "https://github.com/Athena-OS/athena-blue-base";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
})
