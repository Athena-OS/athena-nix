{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-blue-base";
  version = "0-unstable-2025-06-21";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-blue-base";
    rev = "0c41f73c589add7bbd7ce62f823ec3f636cebc58";
    hash = "sha256-7XkRsPf3mdp9jQj2YVBP72zSGSvARRd0bbTOKGILkL0=";
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
