{
  # Description of the repository
  description = "Infrastructure as Code repository for managing my computer configurations";

  # External inputs
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  # Outputs definition
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      # Import the utility functions
       util = (import ./overlays/util.nix 0 0).util;

      # Import nixpkgs and apply overlays
      pkgs = import nixpkgs {
        inherit system;
        overlays = util.nixFilesIn ./overlays;
      };
    in {
      # Define packages
      packages = {
        fs_cli = pkgs.callPackage ./fs/cli.nix {};
      };
    });
}
