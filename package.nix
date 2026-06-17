pkgs : gohip : gp :

let
  vpnc-script-wrapper = pkgs.writeShellScriptBin "vpnc-script" ''
    bash ${pkgs.vpnc-scripts}/bin/vpnc-script "$@"
  '';
  ds-connect-me = pkgs.writeShellScriptBin "ds-connect-me" ''
    sudo -E \
      GP_AUTH_BINARY="${gp.packages.x86_64-linux.default}/bin/gpauth" \
      ${gp.packages.x86_64-linux.default}/bin/gpclient  \
        connect \
        --script ${vpnc-script-wrapper}/bin/vpnc-script \
        --hip "${gohip.packages.x86_64-linux.default}"/bin/gohip \
        global-connect-me.twdc.technology
  '';
  ds-connect-me-old = pkgs.writeShellScriptBin "ds-connect-me-old" ''
    sudo -E \
      ${gp.packages.x86_64-linux.default}/bin/gpclient  \
        --fix-openssl \
        connect \
        --script ${vpnc-script-wrapper}/bin/vpnc-script \
        --hip "${gohip.packages.x86_64-linux.default}"/bin/gohip \
        ds-connect-me.disney.com
  '';
in
  {inherit ds-connect-me ds-connect-me-old;}
