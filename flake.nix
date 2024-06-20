{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    gohip.url = "github:bechampion/gohip/v0.3.1";
    gp.url = "github:marcesquerra/GlobalProtect-openconnect";
  };
  outputs = { self, nixpkgs, flake-utils, gohip, gp }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [ ];
          pkgs = import nixpkgs {
            inherit system overlays;
          };

          generated-packages = (import ./package.nix) pkgs gohip gp;

        in
        with pkgs;
        {
          devShells.default = (import ./shell.nix) pkgs;
          apps = rec {
            ds-connect-me = flake-utils.lib.mkApp {
              drv = generated-packages.ds-connect-me;
            };
            default = ds-connect-me;
          };
          packages = rec {
            ds-connect-me = generated-packages.ds-connect-me;
            default = ds-connect-me;
          };
        }
      );

}
