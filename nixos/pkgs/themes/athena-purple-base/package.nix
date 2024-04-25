{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-purple-base";
  version = "0-unstable-2024-02-10";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-purple-base";
    rev = "32993ef350ea27d9100ed48a0d9d1f715485eba9";
    hash = "sha256-6SbGy8UhymXZjxyGuCpo0PghI4GNpVCfMEpzI0NzZJs=";
  };

  installPhase = ''
    mkdir -p $out/share/{icons/hicolor/scalable/{apps,categories},backgrounds/athena,themes}
    cp -r icons/apps/* $out/share/icons/hicolor/scalable/apps/
    cp -r icons/categories/* $out/share/icons/hicolor/scalable/categories/
    cp -r neon-circle.jpg nix-neon-circle.jpg $out/share/backgrounds/athena/
  '';

  meta = with lib; {
    description = "Purple colorbase resources";
    homepage = "https://github.com/Athena-OS/athena-purple-base";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
})