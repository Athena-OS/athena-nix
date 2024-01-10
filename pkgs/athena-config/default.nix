{ lib
, stdenv
, fetchFromGitHub
, pciutils
, bash
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "athena-config";
  version = "unstable-2024-01-04";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-config";
    rev = "3ec186b227d25fe810d66162e6eb84168af8a09e";
    hash = "sha256-7c9UDPUHjgIjwN19ZezCLCS1atc+sGKYi088tb/hFfY=";
  };

  buildInputs = [ pciutils ];

  postPatch = ''
    patchShebangs athena-motd shell-rocket troubleshoot
    substituteInPlace bin/shell-rocket \
      --replace /usr/bin/bash ${lib.getExe bash}
  '';

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp -r bin/* $out/bin/
    cp -r share/* $out/share/
  '';

  meta = with lib; {
    description = "Athena OS environment files";
    mainProgram = "athena-config";
    homepage = "https://github.com/Athena-OS/athena-config";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
})
