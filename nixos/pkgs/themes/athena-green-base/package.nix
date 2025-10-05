{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-green-base";
  version = "0-unstable-2025-10-05";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-green-base";
    rev = "9f2ea3afc96e21fed96f5663606b8b1b9c3240fd";
    hash = "sha256-gCA1duRkIYA72SFF4oN2hhbz7zQEHd0ukTur281ddog=";
  };

  postPatch = ''
    substituteInPlace gnome-background-properties/*.xml \
      --replace-fail /usr/share/backgrounds $out/share/backgrounds
  '';

  installPhase = ''
    mkdir -p $out/share/{icons/hicolor/scalable/{apps,categories},backgrounds/athena,gnome-background-properties}
    cp -r icons/apps/* $out/share/icons/hicolor/scalable/apps/
    cp -r icons/categories/* $out/share/icons/hicolor/scalable/categories/
    cp -r wallpapers/hackthebox.png $out/share/backgrounds/athena/
    cp -r wallpapers/nix-hackthebox.png $out/share/backgrounds/athena/
    cp -r gnome-background-properties/hackthebox.xml $out/share/gnome-background-properties/
    cp -r gnome-background-properties/nix-hackthebox.xml $out/share/gnome-background-properties/
  '';

  meta = with lib; {
    description = "Green colorbase resources";
    homepage = "https://github.com/Athena-OS/athena-green-base";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
})
