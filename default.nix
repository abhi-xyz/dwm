{
  pkgs,
  configFile ? null,
}:
pkgs.stdenv.mkDerivation {
  pname = "dwm";
  version = "patched";

  src = pkgs.lib.cleanSource ./.;

  # nativeBuildInputs are tools needed on the host to compile the program
  nativeBuildInputs = with pkgs; [
    pkg-config 
  ];

  # buildInputs are the libraries the program links against
  buildInputs = with pkgs; [
    xorg.libX11
    xorg.libXft
    xorg.libXinerama
    pango        
    glib         # Pango usually requires glib
  ];

  postUnpack =
    if configFile != null
    then ''
      echo "🔧 Overriding config.h"
      cp ${configFile} $sourceRoot/config.h
    ''
    else ''
      echo "⚙️  Using default config.h from source"
    '';

  installPhase = ''
    mkdir -p $out/bin
    make PREFIX=$out install
  '';

  meta = {
    description = "Patched DWM from local source";
    homepage = "https://dwm.suckless.org/";
    license = pkgs.lib.licenses.mit;
    platforms = pkgs.lib.platforms.linux;
  };
}
