{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      util = (import ./overlays/util.nix 0 0).util;
      pkgs = import nixpkgs {
        inherit system;
        overlays = util.nixFilesIn ./overlays;
      };
    in {
      packages = {
        fs_cli = pkgs.callPackage ./fs/cli.nix {};
      };
    });
}
