{
  flake.modules.homeManager.gh =
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
