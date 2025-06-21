{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-gruvbox-base";
  version = "0-unstable-2025-06-21";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-gruvbox-base";
    rev = "1ffba73796771c1b2a7744951b38c11425ff7123";
    hash = "sha256-Vkwkq0XcjfrSYo4AvG6gwl4NqmqqOrIBavS7nZ7YCTI=";
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
