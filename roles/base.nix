{ pkgs, ... }:
{
  # Necessary for using flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow unfree software
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    pkgs.vim

    # Nix LSP / Formatting / Docs
    pkgs.nixd
    pkgs.nil
    pkgs.nixfmt-rfc-style
    pkgs.nixdoc
  ];
}
