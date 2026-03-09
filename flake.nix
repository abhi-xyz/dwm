{
  description = "Patched DWM build";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
   
    font = pkgs.nerd-fonts.iosevka-term;

    autostart = pkgs.writeShellScriptBin "autostart_script" ''
      ${pkgs.feh}/bin/feh --bg-scale /home/abhi/.background-image &
      '';

    dwm = pkgs.dwm.overrideAttrs (final: prev: {
      src = pkgs.lib.cleanSource ./.;
      version = "patched";
      nativeBuildInputs = prev.nativeBuildInputs ++ [
        pkgs.pkg-config
        pkgs.makeWrapper
      ];
      buildInputs = prev.buildInputs ++ [
        pkgs.pango
        pkgs.glib
      ];
      postPatch = ''
  substituteInPlace config.h \
    --replace '"autostart.sh"' '"${autostart}/bin/autostart_script"'
'';
      postInstall = ''
  wrapProgram $out/bin/dwm \
    --prefix XDG_DATA_DIRS : "${font}/share"
'';
    });
  in {
    packages.x86_64-linux.default = dwm;
    defaultPackage.x86_64-linux = dwm;
  };
}
