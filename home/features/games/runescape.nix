{ pkgs, config, ... }:
let
  # Add PULSE_LATENCY_MSEC to .desktop file
  pulse_latency = 100;
  runescape = pkgs.runescape.overrideAttrs (oa: {
    nativeBuildInputs = (oa.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
    buildCommand =
      (oa.buildCommand or "")
      + ''
        wrapProgram "$out/bin/RuneScape" \
          --set PULSE_LATENCY_MSEC ${toString pulse_latency} \
          --run 'echo $PULSE_LATENCY_MSEC'
      '';
  });
in
{
  home.packages = [ runescape ];

  home.persistence = {
    "/persist/home/${config.home.username}" = {
      allowOther = true;
      directories = [ "Jagex" ];
    };
  };
}
