with (import <nixpkgs> {});
let
  fnlove = pkgs.writeShellScriptBin "fnlove" ''
    shopt -s globstar

    build () {
      mkdir -p .build/
      rm -rf .build/*
      cp -r src/* .build/

      for f in .build/**/*.fnl
      do 
        fennel --compile $f > ''${f%.fnl}.lua
        rm $f
      done

      echo "Built! 🦾"
    }

    run () {
      build
      echo "Running love with .build/ 💖"
      love .build/
      echo "Closed"
    }

    publish () {
      build
      zip -9 -r $1.love .build/
    }

    case $1 in
      build)
        build
        ;;
      run)
        run
        ;;
      publish)
        publish $2
        ;;
      *)
        echo "Please supply an argument."
        ;;
    esac
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

    fnlove
    love
  ];
}
