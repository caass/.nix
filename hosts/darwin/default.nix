args @ {
  self,
  darwin,
  sharedModules,
  ...
}: let
  # Wrapper function for generating darwin config
  darwinConfig = {
    hostName,
    arch,
  }: let
    # Shared configuration across all darwin hosts
    baseConfig = {
      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "${arch}-darwin";
    };

    # Import per-host config
    hostConfig =
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
          baseConfig
          hostConfig
        ];
    };
  };
in
  darwinConfig {
    hostName = "side-project-generation-machine";
    arch = "aarch64";
  }
