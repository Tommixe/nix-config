{
  flake.modules.homeManager.base =
    { pkgs, config, lib, ... }:
    {
      programs.gh = {
        enable = true;
        extensions = with pkgs; [ gh-markdown-preview ];
        settings = {
          git_protocol = "ssh";
          prompt = "enabled";
        };
      };
      
      # home.persistence = {
      #    "/persist/home/${config.home.username}".directories = [ ".config/gh" ];
      #  };
       
    home.persistence = lib.mkIf (config.home ? persistence) {
        "/persist/home/${config.home.username}".directories = [ ".config/gh" ];
      };
    };
}
