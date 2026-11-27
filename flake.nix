{
  description = "KVision - Cross-platform NVR and IP camera viewing application";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      kvision = pkgs.libsForQt5.callPackage ./packaging/nix/default.nix { };
    in
    {
      packages.${system} = {
        inherit kvision;
        default = kvision;
      };

      apps.${system} = {
        kvision = {
          type = "app";
          program = "${kvision}/bin/kvision";
          meta = kvision.meta;
        };
        default = self.apps.${system}.kvision;
      };

      overlays.default = final: prev: {
        kvision = final.libsForQt5.callPackage ./packaging/nix/default.nix { };
      };

      devShells.${system}.default = pkgs.mkShell {
        inputsFrom = [ kvision ];
      };
    };
}
