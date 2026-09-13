{
  description = "My NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://cachecloud.tzero.it"
    ];
    extra-trusted-public-keys = [
      "cachecloud.tzero.it:0d35aEumDjIuR27iqi5FgnFPmM1ppRpsu43aQx6xcpM="
      "cache.tzero.it:C3XpjhEEHIEz9Ygh5ZjTlv7Gh4a0In09hY66hmssDls="
    ];
  };

  inputs = {

    #https://nixos.org/channels/nixos-unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    flake-parts.url = "github:hercules-ci/flake-parts";

    systems.url = "github:nix-systems/default";

    import-tree.url = "github:vic/import-tree";

    hardware.url = "github:nixos/nixos-hardware";

    impermanence.url = "github:nix-community/impermanence";

    nix-colors.url = "github:misterio77/nix-colors";

    sops-nix.url = "github:mic92/sops-nix";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nix-flatpak.url = "github:gmodena/nix-flatpak/main";

    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";

    #disko.inputs.nixpkgs-stable.follows = "nixpkgs";

    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    home-manager = {
      #url = "github:nix-community/home-manager";
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pconf = {
      #url = "git+ssh://git@github.com/Tommixe/nixos-pconf";
      url = "github:Tommixe/nixos-pconf";
    };

    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      # PR #456 adds XBOOTLDR support (not yet merged)
      url = "git+https://github.com/nix-community/lanzaboote?ref=refs/pull/456/head";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

}
