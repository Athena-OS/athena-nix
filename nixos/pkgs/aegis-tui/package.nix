{ lib
, stdenvNoCC
, fetchFromGitHub
, makeWrapper
, gum
, openssl
}:

stdenvNoCC.mkDerivation {
  pname = "aegis-tui";
  version = "0-unstable-2024-04-14";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "aegis-tui";
    rev = "781333647f29b54d99c7203bfd275d80a69d2ca6";
    hash = "sha256-xjBQT4E0w6y1FPUEqZiFRHcKmAQnlZHxE7vudWIiDRc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    patchShebangs aegis-tui
    substituteInPlace aegis-tui \
      --replace gum ${lib.getExe gum} \
      --replace openssl ${lib.getExe openssl} \
      --replace /usr/share/aegis-tui $out/share/aegis-tui \
      --replace /usr/share/aegis-tui/keymaps $out/share/aegis-tui/keymaps \
      --replace /usr/share/aegis-tui/locales $out/share/aegis-tui/locales
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/aegis-tui}
    cp aegis-tui keymaps locales $out/share/aegis-tui/
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
