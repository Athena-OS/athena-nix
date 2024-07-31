{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-cyan-base";
  version = "0-unstable-2024-06-29";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-cyan-base";
    rev = "b63cc939b8a068affadbb715fd54ee5625186247";
    hash = "sha256-m2i8DpYrbgPMvtW2WxG12ebDY3Ur31Bzxed1r8MdjjY=";
  };

  installPhase = ''
    mkdir -p $out/share/{icons/hicolor/scalable/{apps,categories},backgrounds/athena}
    cp -r icons/apps/* $out/share/icons/hicolor/scalable/apps/
    cp -r icons/categories/* $out/share/icons/hicolor/scalable/categories/
    cp -r samurai-girl.jpg $out/share/backgrounds/athena/
    cp -r temple.png $out/share/backgrounds/athena/
  '';

  meta = with lib; {
    description = "Cyan colorbase resources";
    homepage = "https://github.com/Athena-OS/athena-cyan-base";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
})
