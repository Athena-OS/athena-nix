{ lib
, fetchFromGitHub
, runtimeShell
, python3
, gobject-introspection
, libwnck
, glib
, gtk3
, python3Packages
, wrapGAppsHook
}:

python3Packages.buildPythonApplication {
  pname = "athena-welcome";
  version = "0-unstable-2025-10-19";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-welcome";
    rev = "40a897170e3e3eb7df44154e56d18fa17309947b";
    hash = "sha256-KLmN4qT3+AmFrbGCzzkRoHyfOgttURA+82Kn7C1dPlY=";
  };

  format = "other";
  
  nativeBuildInputs = [ gobject-introspection wrapGAppsHook ];
  buildInputs = [ glib gtk3 libwnck ];
  propagatedBuildInputs = with python3Packages; [ pygobject3 ];

  makeWrapperArgs = [
    "--set GI_TYPELIB_PATH \"$GI_TYPELIB_PATH\""
  ];

  postPatch = ''
    substituteInPlace athena-welcome.desktop \
      --replace /usr/bin/athena-welcome $out/bin/athena-welcome
    substituteInPlace athena-welcome/ui/GUI.py \
      --replace images/htb.png $out/share/athena-welcome/images/htb.png
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/applications,share/athena-welcome,share/icons/hicolor/scalable/apps}
    cp -r athena-welcome.desktop $out/share/applications/athena-welcome.desktop
    cp -r athena-welcome/* $out/share/athena-welcome/
    cp -r athenaos.svg $out/share/icons/hicolor/scalable/apps/
    makeWrapper ${python3}/bin/python $out/bin/athena-welcome \
      --add-flags "$out/share/athena-welcome/athena-welcome.py" \
      --prefix PYTHONPATH : "$PYTHONPATH"
    runHook postInstall
  '';

  postInstall = ''
    install -Dm644 athena-welcome.desktop $out/etc/xdg/autostart/athena-welcome.desktop
  '';

  meta = with lib; {
    description = "Athena Welcome application";
    mainProgram = "athena-welcome";
    homepage = "https://github.com/Athena-OS/athena-welcome";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}
