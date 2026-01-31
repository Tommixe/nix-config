{
  config,
  ...
}:
{

  homeHosts.user01 = {
    unstable = true;
    modules = with config.flake.modules.homeManager; [
      home-manager-user01
    ];
  };
}
