{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
, coreutils
, noto-fonts-color-emoji
, gnome
, imagemagick
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
    rev = "58e00e5e63f644fb6a2d7f9ccd73671019d164fa";
    hash = "sha256-rVjR+bvxa/HSqjuN6Vmkz6/yYj+IGnRkSnSvnZsB5vw=";
  };

  cargoHash = "sha256-o71/BbCTTfUDDAxAPmeWy86CmiGuRUTovxkb5hCOLCc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    coreutils
    noto-fonts-color-emoji
    gnome.gnome-keyring
    imagemagick
    libsecret
    openssl
    openvpn
    #nerdfonts
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  postPatch = ''
    substituteInPlace src/manage.rs \
      --replace /usr/share/htb-toolkit/icons/ $out/share/htb-toolkit/icons/
    substituteInPlace src/utils.rs \
      --replace /usr/bin/bash ${bash}
  '';

  meta = with lib; {
    description = "Play Hack The Box directly on your system";
    homepage = "https://github.com/D3vil0p3r/htb-toolkit";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ d3vil0p3r ];
    mainProgram = "htb-toolkit";
  };
}
