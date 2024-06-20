pkgs : gohip : gp :

let
  vpnc-script-wrapper = pkgs.writeShellScriptBin "vpnc-script" ''
    bash ${pkgs.vpnc-scripts}/bin/vpnc-script "$@"
  '';
  ds-connect-me = pkgs.writeShellScriptBin "ds-connect-me" ''
    sudo -E \
      GP_AUTH_BINARY="${gp.packages.x86_64-linux.gpauth}/bin/gpauth" \
      ${gp.packages.x86_64-linux.gpclient}/bin/gpclient --ignore-tls-errors \
        connect \
        --script ${vpnc-script-wrapper}/bin/vpnc-script \
        --hip \
        --csd-wrapper "${gohip.packages.x86_64-linux.default}"/bin/gohip \
        ds-connect-me.disney.com
  '';
in
  {inherit ds-connect-me;}
