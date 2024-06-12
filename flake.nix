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
            gpservice = flake-utils.lib.mkApp {
              drv = generated-packages.gpservice;
            };
            gpauth = flake-utils.lib.mkApp {
              drv = generated-packages.gpauth;
            };
            ds-connect-me = flake-utils.lib.mkApp {
              drv = generated-packages.ds-connect-me;
            };
            default = gpclient;
          };
          packages = rec {
            gpclient = generated-packages.gpclient;
            gpservice = generated-packages.gpservice;
            gpauth = generated-packages.gpauth;
            ds-connect-me = generated-packages.ds-connect-me;
            default = gpclient;
          };
        }
      );

}
