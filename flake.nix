{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      lix-module,
      ...
    }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#side-project-generation-machine
      darwinConfigurations."side-project-generation-machine" = nix-darwin.lib.darwinSystem {
        modules = [
          {
            # Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;
          }
          ./machines/macbook/configuration.nix
          lix-module.nixosModules.default
        ];
      };
    };
}
