{ pkgs, ... }:

with pkgs;

[
  amoco
  android-udev-rules
  apkid
  apkleaks
  apktool
  binwalk
  bsdiff
  capstone
  cargo-ndk
  ctypes_sh
  cutter
  cutterPlugins.rz-ghidra
  dex2jar
  edb
  eresi
  flasm
  frida-tools
  ghidra
  ghost
  # https://github.com/NixOS/nixpkgs/issues/425348
  # hopper
  iaito
  jadx
  jsbeautifier
  kalibrate-rtl
  klee
  lief
  pe-bear
  pev
  pwntools
  # https://github.com/NixOS/nixpkgs/issues/425357
  # python313Packages.angrop
  python313Packages.distorm3
  python313Packages.frida-python
  python313Packages.pwntools
  python313Packages.pyaxmlparser
  python313Packages.pyjsparser
  quark-engine
  radare2
  retdec
  rizin
  rizinPlugins.rz-ghidra
  # https://github.com/NixOS/nixpkgs/issues/425430
  # scanmem
  # swftools # Insecure
  udis86
  vivisect
]
