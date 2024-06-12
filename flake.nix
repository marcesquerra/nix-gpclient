{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [];
          pkgs = import nixpkgs {
            inherit system overlays;
          };
          generated-packages = (import ./package.nix) pkgs;

        in
        with pkgs;
        {
          devShells.default = (import ./shell.nix) pkgs;
          apps = rec {
            gpclient = flake-utils.lib.mkApp {
              drv = generated-packages.gpclient;
            };
            gpauth = flake-utils.lib.mkApp {
              drv = generated-packages.gpauth;
            };
            default = gpclient;
          };
          packages = rec {
            gpclient = generated-packages.gpclient;
            gpauth = generated-packages.gpauth;
            default = gpclient;
          };
        }
      );

}
