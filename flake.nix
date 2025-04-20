{
  description = "Nvim-Cfg flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.devshell.flakeModule
      ];
      perSystem = {pkgs, ...}: {
        treefmt = {
          flakeCheck = false;

          programs = {
            #typos.enable = true;
            ## Nix
            alejandra.enable = true;
            deadnix.enable = true;
            statix.enable = true;
            ## Lua
            stylua.enable = true;
          };

          projectRootFile = "flake.nix";
        };

        devshells.default = {
          packages = builtins.attrValues {
            inherit(pkgs)
              stylua
            ;
          };
        };
      };
    };
}