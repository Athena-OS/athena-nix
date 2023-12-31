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
    rev = "b7dcc50520e41c2af96b5e1558068fcd3634e009";
    hash = "sha256-7t4y20CbQEh0J5BgDUqwtcyMdPq0GvWQaXdzKft0+hA=";
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
