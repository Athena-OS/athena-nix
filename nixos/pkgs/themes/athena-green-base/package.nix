{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-green-base";
  version = "0-unstable-2024-02-10";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-green-base";
    rev = "a74e5d84ad73dd4e874f694e747c6cb5289cd39c";
    hash = "sha256-fJxzVP2SCffyv9Y2EctCYxlAvDefV90PhedRVSTGa/w=";
  };

  installPhase = ''
    mkdir -p $out/share/{icons/hicolor/scalable/{apps,categories},backgrounds/athena,themes}
    cp -r icons/apps/* $out/share/icons/hicolor/scalable/apps/
    cp -r icons/categories/* $out/share/icons/hicolor/scalable/categories/
    cp -r hackthebox.png $out/share/backgrounds/athena/
    cp -r nix-hackthebox.png $out/share/backgrounds/athena/
    cp -r HackTheBox $out/share/icons/
    cp -r HackTheBox-GTK-Theme/HackTheBox-B $out/share/themes/
    cp -r HackTheBox-GTK-Theme/HackTheBox-BBL $out/share/themes/
    cp -r HackTheBox-GTK-Theme/HackTheBox-BL $out/share/themes/
  '';

  meta = with lib; {
    description = "Green colorbase resources";
    homepage = "https://github.com/Athena-OS/athena-green-base";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
})