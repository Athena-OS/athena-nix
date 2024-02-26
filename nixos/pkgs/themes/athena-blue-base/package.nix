{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-blue-base";
  version = "0-unstable-2024-02-10";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-blue-base";
    rev = "8a8219e1d05e12190edccf35fbbc6f45fbec3558";
    hash = "sha256-6he92Nz2mFnf4v24M9XIqc3EULcTgTpLigS/dnuOzaA=";
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
