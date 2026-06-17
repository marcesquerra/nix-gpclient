{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
    gohip.url = "github:bechampion/gohip/main";
    GlobalProtect-openconnect.url = "github:yuezk/GlobalProtect-openconnect";
  };
  outputs = { self, nixpkgs, flake-utils, gohip, GlobalProtect-openconnect }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [ ];
          pkgs = import nixpkgs {
            inherit system overlays;
          };

          generated-packages = (import ./package.nix) pkgs gohip GlobalProtect-openconnect;

        in
        with pkgs;
        {
          devShells.default = (import ./shell.nix) pkgs [ generated-packages.ds-connect-me generated-packages.ds-connect-me-old ];
          apps = rec {
            ds-connect-me = flake-utils.lib.mkApp {
              drv = generated-packages.ds-connect-me;
            };
            ds-connect-me-old = flake-utils.lib.mkApp {
              drv = generated-packages.ds-connect-me-old;
            };
            default = ds-connect-me;
          };
          packages = rec {
            ds-connect-me = generated-packages.ds-connect-me;
            ds-connect-me-old = generated-packages.ds-connect-me-old;
            default = ds-connect-me;
          };
        }
      );

}
