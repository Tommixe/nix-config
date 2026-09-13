{
  flake.modules.homeManager.hm = {
       # Let Home Manager install and manage itself.
     programs = {
         home-manager.enable = true;
         git.enable = true;
       };
  };
}