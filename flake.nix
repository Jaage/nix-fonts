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
          src = pkgs.fetchurl {
            url = "https://github.com/runelite/runelite/blob/master/runelite-client/src/main/resources/net/runelite/client/ui/runescape.ttf";
            sha256 = "sha256-GNOAfqJ+wSPO6HBsMIiu7XyDlNmms8My+YQP8BrsxxM=";
          };
          installPhase = ''
            mkdir -p $out/share/fonts/truetype
            cp -R $src $out/share/fonts/truetype/
          '';
          meta = {
            description = "The Runescape Font Family derivation.";
          };
        };
      }
    );
}
