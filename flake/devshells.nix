{
  inputs,
  lib,
  ...
}: let
  customLib = import (inputs.infra-nixCfg + "/lib/custom.nix") {inherit (inputs.nixpkgs) lib;};
in {
  imports = [inputs.devshell.flakeModule];

  perSystem = {
    pkgs,
    config,
    ...
  }: {
    devshells.default = {
      devshell = rec {
        name = "Vim-Cfg";
        motd = "{202}Welcome to {91}${name} {202}devshell!{reset} \n $(menu)";
        startup = {
          git-hooks.text = ''
            ${config.pre-commit.installationScript}
          '';
        };
        packages = lib.attrsets.attrValues {
          inherit
            (pkgs)
            ### LSPs & Formatters
            nixd
            alejandra
            stylua
            ### nvim-treesitter (main) builds parsers with the CLI
            tree-sitter
            ;
          ## AI context
          apm = customLib.mkUvxBin pkgs "apm" "--from apm-cli apm";
        };
      };
    };
  };
}
