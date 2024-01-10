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
    rev = "0faab7db54977588fa6651c62d41639c37c75c5f";
    hash = "sha256-p5ewUfnt00Tcz02Y5vry4jrDlrItn0E5sGqFHCWj1v4=";
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
