args @ {
  self,
  darwin,
  sharedModules,
  home-manager,
  vars,
  ...
}: let
  # Wrapper function for generating darwin config
  darwinConfig = {
    hostName,
    arch,
  }: let
    # Shared configuration across all darwin hosts
    baseModule = {
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "${arch}-darwin";

      # Tell home-manager where to manage our home
      users.users.${vars.user}.home = /Users/${vars.user};
    };

    # Import per-host config
    hostModule =
      import (
        if builtins.pathExists ./${hostName}/default.nix
        then ./${hostName}
        else if builtins.pathExists ./${hostName}.nix
        then ./${hostName}.nix
        else throw "Couldn't find a file at ./${hostName}"
      )
      args;
  in {
    "${hostName}" = darwin.lib.darwinSystem {
      modules =
        sharedModules
        ++ [
          home-manager.darwinModules.home-manager
          baseModule
          hostModule
        ];
    };
  };
in
  darwinConfig {
    hostName = "side-project-generation-machine";
    arch = "aarch64";
  }
