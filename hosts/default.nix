baseArgs @ {lix, ...}: let
  # Configuration module used across all hosts
  sharedConfig = {pkgs, ...}: {
    # Packages we want on every system
    environment.systemPackages = [
      # Escape hatch editor
      pkgs.vim

      # Tools to help write nix
      pkgs.nixd
      pkgs.nil
      pkgs.alejandra
      pkgs.nixdoc

      # Tools to help understand nix
      pkgs.nix-diff
    ];

    # Necessary for using flakes
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Modules used across all different hosts
  sharedModules = [
    sharedConfig
    lix.nixosModules.default
  ];

  args =
    baseArgs
    // {
      inherit sharedModules;
    };
in {
  darwinConfigurations = import ./darwin args;
}
