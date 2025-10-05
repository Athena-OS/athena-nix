{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-gruvbox-base";
  version = "0-unstable-2025-10-05";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-gruvbox-base";
    rev = "f00878d501f2bd5b422401f843da006e592bca36";
    hash = "sha256-BfFaF19wFFGWUljcddOv4LgVUwJPIdkg+K93yGh5PJg=";
  };

  postPatch = ''
    substituteInPlace gnome-background-properties/*.xml \
      --replace-fail /usr/share/backgrounds $out/share/backgrounds
  '';

  installPhase = ''
    mkdir -p $out/share/{icons/hicolor/scalable/{apps,categories},backgrounds/athena,gnome-background-properties}
    cp -r icons/apps/* $out/share/icons/hicolor/scalable/apps/
    cp -r icons/categories/* $out/share/icons/hicolor/scalable/categories/
    cp -r wallpapers/cyborg-gruv.png $out/share/backgrounds/athena/
    cp -r gnome-background-properties/cyborg-gruv.xml $out/share/gnome-background-properties/
  '';

  meta = with lib; {
    description = "Gruvbox colorbase resources";
    homepage = "https://github.com/Athena-OS/athena-gruvbox-base";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
})
