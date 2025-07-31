{
  description = "A flake that installs fonts not in Nixpkgs.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        defaultPackage = pkgs.symlinkJoin {
          name = "myfonts-0.1.0";
          paths = builtins.attrValues self.packages.${system}; # Add font derivation names here
        };

        packages.runescape = pkgs.stdenvNoCC.mkDerivation {
          name = "runescape-font";
          dontUnpack = true;
          src = "${self}/RuneScape";
          installPhase = ''
            mkdir -p $out/share/fonts/truetype
            cp -R $src/* $out/share/fonts/truetype/
          '';
          meta = {
            description = "The Runescape Font Family derivation.";
          };
        };
      }
    );
}
