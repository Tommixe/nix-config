{
  flake.modules.homeManager.base = {
    home.stateVersion = "23.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}