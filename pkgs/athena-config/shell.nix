with import <nixpkgs> {};
let 
  athena-config = pkgs.callPackage ./package.nix { };
in
  stdenv.mkDerivation rec {
    name = "env";
    
    buildInputs = [
      curl
      git
      nix
      athena-config
    ];
  }