pkgs : extra-packages : 

pkgs.mkShell {
  buildInputs = [ ] ++ extra-packages;
}
