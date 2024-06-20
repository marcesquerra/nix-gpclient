# nix-gpclient

Nix Wrapper around (a fork of) GlobalProtect-openconnect for NixOS.

Usage:
  1) Ensure you have `clam` installed in your OS
  2) Install the `ds-connect-me` flake in this repo
  3) run `ds-connect-me`

That's about it, it should take care of everything. First time will take some time to
compile everything.

To run the VPN without installing the flake, if you have clam installed, you can run
the following command from this repo:

```
nix run .#ds-connect-me
```
