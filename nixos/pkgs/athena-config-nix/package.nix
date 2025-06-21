{ lib
, stdenvNoCC
, fetchFromGitHub
, pciutils
, bash
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-config-nix";
  version = "0-unstable-2025-06-21";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-config-nix";
    rev = "75977a4d6a8d2aad1afce80e8f9e30ab33d73176";
    hash = "sha256-CpXeybJf+FT6XRatCubKB9XJVHS+eyF+m+jtiDi1cJg=";
  };

  buildInputs = [ pciutils ];

  postPatch = ''
    patchShebangs athena-motd shell-rocket troubleshoot
  '';

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp -r bin/* $out/bin/
    cp -r share/* $out/share/
  '';

  meta = with lib; {
    description = "Athena OS environment files";
    homepage = "https://github.com/Athena-OS/athena-config-nix";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
})
