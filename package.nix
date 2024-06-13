pkgs :

let
  sha256 = "sha256-P1ByOzRouyYJtfRTGZb2B1e/3+G1xnFTRgVwiyHPfMc=";
  binary = pkgs.stdenv.mkDerivation rec {
    pname = "globalprotect-openconnect";
    version = "2.3.1";  # Update this to your desired rover version
    
    src = pkgs.fetchurl {
      url = "https://github.com/yuezk/GlobalProtect-openconnect/releases/download/v${version}/globalprotect-openconnect_${version}_x86_64.bin.tar.xz";
      sha256 = sha256;
    };
    
    # Extract and install the binary
    installPhase = ''
        mkdir -p $out/bin
        cp -r artifacts/usr/bin/* $out/bin/
      '';
    buildPhase = ''
        echo "ignored"
      '';
  };
  gpclient = (pkgs.buildFHSUserEnv {
    name = "gpclient";
    runScript = pkgs.writeShellScript "gpclient.sh" ''
      if [ $PWD = "/build" ]
      then
        exit 0
      fi
      ${binary}/bin/gpclient "$@"
    '';
    targetPkgs = pkgs: [
      pkgs.openconnect.dev
      pkgs.glibc
      pkgs.zlib
    ];
  });
  gpservice = (pkgs.buildFHSUserEnv {
    name = "gpservice";
    runScript = pkgs.writeShellScript "gpservice.sh" ''
      if [ $PWD = "/build" ]
      then
        exit 0
      fi
      ${binary}/bin/gpservice "$@"
    '';
    targetPkgs = pkgs: [
      pkgs.openconnect.dev
      pkgs.glibc
      pkgs.zlib
    ];
  });
  gpauth = (pkgs.buildFHSUserEnv {
    name = "gpauth";
    runScript = pkgs.writeShellScript "gpauth.sh" ''
      if [ $PWD = "/build" ]
      then
        exit 0
      fi
      ${binary}/bin/gpauth "$@"
    '';
    targetPkgs = pkgs: [
      pkgs.openconnect.dev
      pkgs.glibc
      pkgs.glib
      pkgs.zlib
      pkgs.webkitgtk.dev
      pkgs.gtk3.dev
      pkgs.cairo.dev
      pkgs.cairo.dev
      pkgs.gdk-pixbuf
      pkgs.gnome.libsoup
    ];
  });
  ds-connect-me = pkgs.writeShellScriptBin "ds-connect-me" ''
    PATH="${gpauth}/bin:${gpclient}/bin:${gpservice}/bin:$PATH"
    sudo -E gpclient connect --hip --csd-wrapper $(which gohip) --default-browser ds-connect-me.disney.com
  '';
in
  {inherit gpclient gpservice gpauth ds-connect-me;}
