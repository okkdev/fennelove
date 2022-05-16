with (import <nixpkgs> {});
let
  build = pkgs.writeShellScriptBin "build" ''
    shopt -s globstar

    mkdir -p .build/
    rm -rf .build/*
    cp -r $1/* .build/

    for f in .build/**/*.fnl
    do 
      fennel --compile $f > ''${f%.fnl}.lua
      rm $f
    done

    echo "Built! 🦾"
  '';
  runlove = pkgs.writeShellScriptBin "runlove" ''
    build src/
    echo "Running love with .build/ 💖"
    love .build/
    echo "Closed"
  '';
  love = stdenv.mkDerivation rec {
    name = "love-${version}";
    version = "11.4";
    src = fetchurl {
      url = "https://github.com/love2d/love/releases/download/${version}/love-${version}-macos.zip";
      sha256 = "sha256-BIlgIcvl8fhUjybSq5JREoaZUQ0mdqbvPVRKPZnW98A=";
    };
    buildInputs = [ unzip ];
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      unzip $src -d $out/bin
      ln -s $out/bin/love.app/Contents/MacOS/love $out/bin/love
    '';
  };
in
mkShell {
  buildInputs = [
    fennel
    fnlfmt
    lua5_4

    build
    runlove
    love
  ];
}
