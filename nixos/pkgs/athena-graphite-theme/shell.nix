with import <nixpkgs> {};
let 
  athena-graphite-theme = pkgs.callPackage ./package.nix { };
in
  stdenv.mkDerivation rec {
    name = "env";
    
    buildInputs = [
      curl
      git
      nix
      perl
      athena-graphite-theme
    ];
  }
