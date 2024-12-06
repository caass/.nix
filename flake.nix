{
  description = "cass' flake (◠‿◠✿)*:･ﾟ✧";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    # Variables used for system configuration
    vars = {
      user = "cass";
    };

    # Forward inputs and variables
    args =
      inputs
      // {
        inherit vars;
      };
  in
    import ./hosts args;
}
