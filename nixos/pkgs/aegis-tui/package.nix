{ lib
, stdenvNoCC
, fetchFromGitHub
, makeWrapper
, gum
, openssl
}:

stdenvNoCC.mkDerivation {
  pname = "aegis-tui";
  version = "unstable-2024-01-25";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "aegis-tui";
    rev = "da83a2a08ec168c5a433717da302c14a21ddef16";
    hash = "sha256-vyyVPCQ2yRsy6+WsiEMdTFRWjT9k91DxBwWfEbNijjc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    patchShebangs aegis-tui
    substituteInPlace aegis-tui \
      --replace gum ${lib.getExe gum} \
      --replace openssl ${lib.getExe openssl} \
      --replace /usr/share/aegis-tui $out/share/aegis-tui \
      --replace /usr/share/aegis-tui/locales $out/share/aegis-tui/locales
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/aegis-tui}
    cp aegis-tui locales $out/share/aegis-tui/
    makeWrapper $out/share/aegis-tui/aegis-tui $out/bin/aegis-tui
    runHook postInstall
  '';

  meta = with lib; {
    description = "Aegis - secure, rust-based installer back-end for Athena OS";
    mainProgram = "aegis-tui";
    homepage = "https://github.com/Athena-OS/aegis-tui";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ d3vil0p3r ];
  };
}
