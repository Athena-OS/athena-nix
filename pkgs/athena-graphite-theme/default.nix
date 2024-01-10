{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "athena-graphite-theme";
  version = "unstable-2024-01-10";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-graphite-theme";
    rev = "d692d3e36daf3c05e96851c2136f620a76dd15be";
    hash = "sha256-Xnyolz5St3LIjlra9iemDLIGNzYY2q/y0TuWuZD59ps=";
  };

  installPhase = ''
    mkdir -p $out/share/{icons/hicolor/scalable/{apps,categories},backgrounds/athena}
    cp -r icons/apps/* $out/share/icons/hicolor/scalable/apps/
    cp -r icons/categories/* $out/share/icons/hicolor/scalable/categories/
    cp -r nix-behind.png $out/share/backgrounds/athena/
  '';

  meta = with lib; {
    description = "Graphite Dark theme resources";
    mainProgram = "athena-graphite-theme";
    homepage = "https://github.com/Athena-OS/athena-graphite";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
})
