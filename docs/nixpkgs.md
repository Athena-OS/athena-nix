# Nix Packaging Guidelines

The purpose of this document is to provide guidelines to package tools following Nix best practices.

## Build packages

There are several ways to build local packages. What I'm currently using are `nix-build` and `nix-shell`.

### nix-build

Once you created your `package.nix`, you can use `nix-build` command to build your `package.nix` package file. The arguments of `niix-build` command can change according to the type of package we are trying to build.

In general, to build packages based on usual functions (like `mkDerivation`) require the usage of:
```sh
nix-build -E 'with import <nixpkgs> {}; callPackage ./package.nix {}'
```
Note that, if you are getting an error reporting `abort` string, probably the invoked `callPackage` command is wrong, so you must use some specific case.

For specific cases, it is required to use a little different command:

For Python3 `buildPythonPackage` function:
```sh
nix-build -E 'with import <nixpkgs> {}; python3Packages.callPackage ./package.nix {}'
```

For qmake to be used in `mkDerivation` function:
```sh
nix-build -E 'with import <nixpkgs> {}; libsForQt5.callPackage ./package.nix {}'
```
In this case, remember to use `wrapQtAppsHook`. If it is not needed to wrap, keep it and add `dontWrapQtApps = true;`.

### Build local packages with local dependencies

Refer to https://summer.nixos.org/blog/callpackage-a-tool-for-the-lazy/#3-benefit-flexible-dependency-injection

Another, more effective, method is to use **niix-shell** because you can create an environment where the package and the related dependencies are actually installed in this environment, so the package will be able to retrieve the related dependencies.

Let's guess our main package to test is `guymager` and the related local dependencies to test with are `libewf-legacy`, `libbfio` and `libguytools`. Let's assume you already packaged both of them and they are stored as:
```sh
├── package.nix (guymager)
├── libewf-legacy
│   ├── package.nix
├── libbfio
│   ├── package.nix
├── libguytools
│   ├── package.nix
```
Insert these local dependencies inside `package.nix` of `guymager` because we will add them in our nix-shell environment file.

Now create a `shell.nix` file that will deploy your environment:
```nix
with import <nixpkgs> {};
let 
  libewf-legacy = pkgs.callPackage ./libewf-legacy/package.nix { };
  libbfio = pkgs.callPackage ./libbfio/package.nix { };
  libguytools = pkgs.libsForQt5.callPackage ./libguytools/package.nix { };
  guymager = pkgs.libsForQt5.callPackage ./package.nix { inherit libewf-legacy libbfio libguytools; };
in
  stdenv.mkDerivation rec {
    name = "env";
    
    buildInputs = [
      curl
      git
      nix
      perl
      libewf-legacy
      libbfio
      libguytools
      guymager
    ];
  }
```
Now, run `nix-shell` and, if `package.nix` files don't produce any errors, you should be inside `nix-shell` environment and you can invoke the program to check if the binary of the main program calls the dependency correctly both at build and run time.

### Clean environment

To clean the environment from all the files created by the build process, run `nix-collect-garbage` and remove `result` directories.

## Dependencies

Dependencies can be used by the following expressions:
* nativeBuildInputs: dependencies that should exist in the build environment
* buildInputs: dependencies that should exist in the runtime environment
* propagatedBuildInputs:  dependencies that should exist in the runtime environment and also propagated to downstream runtime environments. Usually used in Python packages

All dependencies used in **buildInputs** allow to link header and lib files correctly during the compilation of a tool.

## mkDerivation

This function automatically compiles source files if a **Makefile** exists. It means that we don't need to specify `make` commands in `buildPhase` or `installPhase`. Indeed, often it is not necessary to write any build instructions because the stdenv build system is based on autoconf, which automatically detected the structure of the project directory. We need only to eventually set make flags if needed. Use `makeFlags` to specify flags used on each phase or `buildFlags` to specify flags to be used only during the `buildPhase`.

For example, if `Makefile` is not in the root directory of the project source, you can instruct mkDerivation to find Makefile by:
```nix
  makeFlags = [
    "-C src"
  ];
```

Add `enableParallelBuilding = true;` to enable parallel building.

Only in case where the structure of the project does not allow to run autoconf process correctly, then we could be forced to write some code in some of nix phases.

### Usage of hooks

#### autoconf

In case your source project contains **configure** files, you can import **autoreconfHook** and use it as:
```nix
nativeBuildInputs = [autoreconfHook];
```
In this manner, it simulates the usage of `autoreconf` command and compile and install the tool.

In case the building produces an error due to, for example, obsolete macros that interrupts the autoconf process, try to use **configure** approach described in the next section.

#### configure

In case the **autoconf** method does not work, try to use this approach.

Some source files use **configure** file during compilation. This file can use arguments as `build` for cross-platform building, `host` and `target`.

Instead to write `./configure --build=arm --prefix=$out` in `buildPhase`, you can use:
```nix
configurePlatforms = [ "build" ];
```
Along with it, `configureFlags` can be used for adding additional flags. In this example we don't add the flag `--prefix=$out` because in Nix the default value of `--prefix` is already `$out`.

### Syntax

When using **mkDerivation** in a `.nix` package file, and its variables need to be used in other elements, instead of using `rec` you can use `finalAttrs`, as the following example:
```nix
  stdenv.mkDerivation (finalAttrs: {
    pname = "maltego";
    version = "4.6.0";
  
    src = fetchzip {
      url = "https://downloads.maltego.com/maltego-v4/linux/Maltego.v${finalAttrs.version}.linux.zip";
      hash = "sha256-q+1RYToZtBxAIDSiUWf3i/3GBBDwh6NWteHiK4VM1HY=";
    };
    ...
  })
```
In this manner, all the declared variables like `pname` or `version` can be accessed by `finalAttrs.<variable-name>`.

## Meta information

**meta** allows to specify several information about the package. The needed fields to set are mainly:
```nix
  meta = with lib; {
    homepage = "https://www.packagetool.com";
    description = "Description of the tool";
    mainProgram = "<tool-name>";
    maintainers = with maintainers; [ <maintainer list separated by space> ];
    platforms = with platforms; <platform list separated by ++>;
    sourceProvenance = with sourceTypes; [ <sourceTypes-value> ];
    license = licenses.<license-type>;
  };
```
You can also use a direct form like `platforms = platforms.unix;`

Some of these fields accept only specific input values. For each one of these fields, to know what are the possible values to use, refer to the following:
* maintainers: [maintainer-list.nix](https://github.com/NixOS/nixpkgs/blob/master/maintainers/maintainer-list.nix) and [team-list.nix](https://github.com/NixOS/nixpkgs/blob/master/maintainers/team-list.nix) or running:
  ```nix
  nix repl -f '<nixpkgs>'
  builtins.attrNames lib.maintainers
  ```
* platforms: 
  ```nix
  nix repl -f '<nixpkgs>'
  builtins.attrNames lib.platforms
  ```
* sourceProvenance:
  ```nix
  nix repl -f '<nixpkgs>'
  builtins.attrNames lib.sourceTypes
  ```
  note that if nothing is specified, the default value is **fromSource**
* license:
  ```nix
  nix repl -f '<nixpkgs>'
  builtins.attrNames lib.licenses
  ```

  Furthermore, the link at **homepage** must be `https`.

## Misc

### Make binary wrapper

The creation of a binary wrapper is very comfortable since it allows to set environment variables along with it. An example:
```nix
  installPhase = ''
    runHook preInstall
  
    mkdir -p $out/{bin,share}
    chmod +x bin/maltego
  
    cp -aR . "$out/share/maltego/"
  
    makeWrapper $out/share/maltego/bin/maltego $out/bin/${finalAttrs.meta.mainProgram} \
      --set JAVA_HOME ${jre} \
      --prefix PATH : ${lib.makeBinPath [ jre ]}
  
    runHook postInstall
  '';
```

### Make a bash wrapper

Currently, to wrap a program in a bash script, it is possible to use:
```nix
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}

    cp -aR . "$out/share/toolname/"

    cat > "$out/bin/${pname}" << EOF
    #!${runtimeShell}
    exec ${perl}/bin/perl $out/share/toolname/toolname.pl "\$@"
    EOF

    chmod u+x  "$out/bin/${pname}"

    runHook postInstall
  '';
```
Some packages in other Linux distributions are wrapped by using `cd` command before using `exec` like:
```nix
  cat > "$pkgdir/usr/bin/$pkgname" << EOF
#!/bin/sh
cd /usr/share/$pkgname/
exec perl ./rip.pl "\${@}"
EOF
```
This approach is usually used because some tool scripts call other files that work, as example, as plugins, by "relative" path as i.e. `./plugins/`. If `cd` was removed, the tool script is not able to find `plugins` directory anymore.

In Nix, this usage of `cd` in wrappers must be discouraged because it forces you to land in `$out/share/toolname` that is inside `/nix/store`. At this point, how can we prevent `cd` usage and still access to paths like `plugins`?

A good strategy is to use `postPatch` and `substituteInPlace` to replace `plugins` by `$out/share/toolname/plugins` inside the tool script files that define the plugin path. An example comes from `regripper` nix package file:
```nix
  postPatch = ''
    substituteInPlace rip.pl rr.pl \
      --replace \"plugins/\" \"$out/share/regripper/plugins/\"
    substituteInPlace rip.pl rr.pl \
      --replace \"plugins\" \"$out/share/regripper/plugins\"
  '';
```

### Usage of macros

The usage of macros in some fields of the `.nix` file is discouraged. For example, in:
```nix
buildPythonPackage rec {
  pname = "pysqlite3";
  version = "0.5.2";
  src = fetchFromGitHub {
    owner = "coleifer";
    repo = pname;
  ...
```
`repo = pname;` must be changed to `repo = "pysqlite3";`. The motivation to avoid the usage of macros/variables on some fiels is explained here: https://github.com/NixOS/nixpkgs/issues/277994

### Source link

If using SourceForge as source, use `mirror://sourceforge/project`.

### Replace code strings

If it is needed to replace code strings inside source files, it is possible to use `substituteInPlace`, usually in `postPatch` for example:
```nix
  postPatch = ''
    substituteInPlace bin/maltego \
      --replace /usr/bin/awk ${lib.getExe gawk} \
      --replace "string" "anotherstring"
  '';
```
To intend, the number of spaces is two.
Note also the usage of `${lib.getExe gawk}`: **lib.getExe** can be used to retrive the path of a binary file.

### Linking libraries

If I'm not wrong, `mkDerivation` should automatically detect `/usr/<path-to-lib>/<lib-file>` at build time and replace `/usr` by `$out`. It occurs when `/usr` as written according to a specific pattern, for example `/usr/local/lib/libguytools.a`.

In case a source file contains something like:
```cpp
const QString ThreadScanLibSearchDirs     = "/lib,/usr/lib,/usr/lib64,/usr/local/lib";  // Separate directories by commas
```
where `ThreadScanLibSearchDirs` will be used as base to find libraries as `libudev` and/or `libparted` at **runtime**, it is needed to change those paths like:
```nix
substituteInPlace threadscan.cpp \
  --replace '/lib,/usr/lib,/usr/lib64,/usr/local/lib' '${builtins.replaceStrings [":"] [","] (lib.makeLibraryPath [ udev parted ])}'
```
It will result in something like:
```cpp
const QString ThreadScanLibSearchDirs     = "/nix/store/2cvhyiblil0vgrcbr4x46pvx9150pqfi-systemd-minimal-libs-254.6/lib,/nix/store/nswzq08675i33c0smqrhyww4r8z3r6v5-parted-3.6/lib";  // Separate directories by commas
```
In case you are using a `substituteInPlace` that replaces `/usr` by `$out` to the file containing the code above, be sure that this general `substituteInPlace` is placed after the `substituteInPlace` of those specific libraries.

If you are dealing with a Java project, you can link libraries at runtime as follows:
```nix
  installPhase = ''
    mkdir -p "$out/lib/java" "$out/share/java"
    cp tool/target/gp.jar "$out/share/java"
    makeWrapper "${jre8_headless}/bin/java" "$out/bin/gp" \
      --add-flags "-jar '$out/share/java/gp.jar'" \
      --prefix LD_LIBRARY_PATH : "${pcsclite.out}/lib"
  '';
```
where `pcsclite` is the dependency package of the needed library.

### Create Desktop file

In a Nix package it is possible to create desktop files by importing `copyDesktopItems` and `makeDesktopItem` and use `desktopItems` as:
```nix
  nativeBuildInputs = [
    copyDesktopItems
  ];
```
and
```nix
  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      desktopName = "Maltego";
      exec = finalAttrs.meta.mainProgram;
      icon = finalAttrs.pname;
      comment = "An open source intelligence and forensics application";
      categories = [ "Network" "Security" ];
      startupNotify = false;
    })
  ];
```

### Create multiple icons from .ico file

If a source project has a `.ico` file, it is possible to generate icon images in different sizes that could be used in the desktop file of the tool. It can be reached by importing `icoutils` and use the following structure:
```nix
  nativeBuildInputs = [
    icoutils
  ];
```
and
```nix
  installPhase = ''
      runHook preInstall
  
      mkdir -p $out/{bin,share}
      chmod +x bin/maltego
  
      icotool -x bin/maltego.ico
  
      for size in 16 32 48 256
      do
        mkdir -p $out/share/icons/hicolor/$size\x$size/apps
        cp maltego_*_$size\x$size\x32.png $out/share/icons/hicolor/$size\x$size/apps/maltego.png
      done
  
      rm -r *.png
  
      cp -aR . "$out/share/maltego/"
  ...
```

