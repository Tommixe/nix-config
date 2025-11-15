{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.gh = {
        enable = true;
        extensions = with pkgs; [ gh-markdown-preview ];
        settings = {
          git_protocol = "ssh";
          prompt = "enabled";
        };
      };

      custom.imp.home.directories = [ ".config/gh"];
      
    };
}
