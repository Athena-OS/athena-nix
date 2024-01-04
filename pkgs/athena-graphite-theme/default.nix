{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "athena-graphite-theme";
  version = "unstable-2024-01-04";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-graphite-theme";
    rev = "020a034b10114d7938d31d3591e1fadb0d861e99";
    hash = "sha256-hQur2KJjD5vubLnkCz4P3OMPBw8dPrp51TabP/z8uyY=";
  };

  installPhase = ''
    mkdir -p $out/share/{icons/hicolor/scalable/{apps,categories},backgrounds/athena}
    cp -r icons/apps/* $out/share/icons/hicolor/scalable/apps/
    cp -r icons/categories/* $out/share/icons/hicolor/scalable/categories/
    cp -r arch-ascii.png $out/share/backgrounds/athena/
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