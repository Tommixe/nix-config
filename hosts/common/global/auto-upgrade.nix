{inputs, config, ...}: {
  system.hydraAutoUpgrade = {
    # Only enable if not dirty
    enable = inputs.self ? rev;
    dates = "hourly";
    instance = "https://hydracloud.tzero.it";
    project = "nix-config";
    jobset = "main";
    job = "hosts.${config.networking.hostName}";
    oldFlakeRef = "self";
  };
}