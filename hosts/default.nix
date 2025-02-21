baseArgs @ {
  lix,
  vars,
  ...
}: let
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

      # SCM
      pkgs.fossil

      # devenv
      pkgs.devenv
    ];

    # Necessary for using flakes
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Nixpkgs config
    nixpkgs.config = {
      # Allow unfree software
      allowUnfree = true;

      # Error on the wrong system
      allowUnsupportedSystem = false;
    };

    home-manager = {
      # tbqh idk what these do
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = baseArgs;

      users.${vars.user} = import ../users/${vars.user};
    };
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
