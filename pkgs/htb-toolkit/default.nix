{ lib
, rustPlatform
, fetchFromGitHub
, makeBinaryWrapper
, pkg-config
, openssl
, stdenv
, darwin
, coreutils
, noto-fonts-color-emoji
, gnome
, libsecret
, bash
, openvpn
, nerdfonts
}:

rustPlatform.buildRustPackage rec {
  pname = "htb-toolkit";
  version = "unstable-2024-01-16";

  src = fetchFromGitHub {
    owner = "D3vil0p3r";
    repo = "htb-toolkit";
    rev = "f4830f5629c8ed171758fb484dd8f0ccf95be512";
    hash = "sha256-QYUqdqFV9Qn+VbJTnz5hx5I0XV1nrzCoCKtRS7jBLsE=";
  };

  cargoHash = "sha256-o71/BbCTTfUDDAxAPmeWy86CmiGuRUTovxkb5hCOLCc=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  propagateBuildInputs = [
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    coreutils
    noto-fonts-color-emoji
    gnome.gnome-keyring
    libsecret
    openvpn
  ];

  postPatch = ''
    substituteInPlace src/manage.rs \
      --replace /usr/share/htb-toolkit/icons/ $out/share/htb-toolkit/icons/
    substituteInPlace src/utils.rs \
      --replace /usr/bin/bash ${bash}
  '';

  postInstall = ''
    mkdir -p $out/bin
    makeBinaryWrapper ${libsecret}/bin/secret-tool $out/bin/secret-tool
    makeBinaryWrapper ${openvpn}/bin/openvpn $out/bin/openvpn
  '';

  meta = with lib; {
    description = "Play Hack The Box directly on your system";
    homepage = "https://github.com/D3vil0p3r/htb-toolkit";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ d3vil0p3r ];
    mainProgram = "htb-toolkit";
  };
}
