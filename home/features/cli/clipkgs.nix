{ pkgs, ... }:
{
  home.packages = with pkgs; [
    comma # Install and run programs by sticking a , before them
    distrobox # Nice escape hatch, integrates docker images with my environment
    bws
    bc # Calculator
    bottom # System viewer
    ncdu # TUI disk usage
    eza # Better ls
    ripgrep # Better grep
    fd # Better find
    httpie # Better curl
    diffsitter # Better diff
    jq # JSON pretty printer and manipulator
    #trekscii # Cute startrek cli printer
    terraform
    nil # Nix LSP
    nixfmt-rfc-style # Nix formatter
    nix-inspect # See which pkgs are in your PATH
    nvd
    sops
    ssh-to-age
    tldr
    fzf
    #ltex-ls # Spell checking LSP
  ];
}
