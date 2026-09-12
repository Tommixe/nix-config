{ inputs, ... }:
{
  flake.modules.nixos.hermes-agent =

    { config, ... }: {

      imports = [ inputs.hermes-agent.nixosModules.default ];

      services.hermes-agent = {
        enable = true;
        container.enable = true;
        container.hostUsers = [ config.global-var.user01 ];
        #settings.model.default = "anthropic/claude-sonnet-4";
        environmentFiles = [ config.sops.secrets."hermes-env".path ];
        addToSystemPackages = true;

        settings = {
          model = {
            provider = "openrouter";
            base_url = "https://openrouter.ai/api/v1";
            default = "openrouter/free";
          };
          toolsets = [ "all" ];
          max_turns = 100;
          terminal = {
            backend = "local";
            cwd = ".";
            timeout = 180;
          };
          compression = {
            enabled = true;
            threshold = 0.85;
            summary_model = "openrouter/free";
          };
          memory = {
            memory_enabled = true;
            user_profile_enabled = true;
          };
          display = {
            compact = false;
            personality = "kawaii";
          };
          agent = {
            max_turns = 60;
            verbose = false;
          };
          skills = {
            external_dirs = [
              "~/skills"
              ];
          };
        };

      };

      sops.secrets."hermes-env" = {
        sopsFile = ./hermes.yaml;
      };

      custom.imp.root.directories = [

        "/var/lib/hermes"

      ];
    };

}
