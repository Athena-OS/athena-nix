{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "athena-sweet-theme";
  version = "unstable-2024-01-14";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-sweet-theme";
    rev = "65468918f472dbcd8fbe9f4c3cbd4c05706c5aae";
    hash = "sha256-q9gwBYCbt36rdFWWSLBlcZ8hsBm5muHdCqMqgiAj3X4=";
  };

  installPhase = ''
    mkdir -p $out/share/{icons/hicolor/scalable/{apps,categories},backgrounds/athena,themes}
    cp -r icons/apps/* $out/share/icons/hicolor/scalable/apps/
    cp -r icons/categories/* $out/share/icons/hicolor/scalable/categories/
    cp -r neon-circle.jpg $out/share/backgrounds/athena/
    cp -r Sweet-Dark-v40 $out/share/themes/
  '';

  meta = with lib; {
    description = "Sweet Dark theme resources";
    homepage = "https://github.com/Athena-OS/athena-sweet-theme";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
})
