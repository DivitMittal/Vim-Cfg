{
  inputs,
  lib,
  ...
}: let
  customLib = import (inputs.OS-nixCfg + "/lib/custom.nix") {inherit (inputs.nixpkgs) lib;};
in {
  imports = [inputs.devshell.flakeModule];

  perSystem = {
    pkgs,
    ...
  }: {
    devshells.default = {
      devshell = rec {
        name = "Vim-Cfg";
        motd = "{202}Welcome to {91}${name} {202}devshell!{reset} \n $(menu)";
        ## Git hooks are installed by `startup.git-hooks` in checks.nix
        packages = lib.attrsets.attrValues {
          inherit
            (pkgs)
            ### LSPs & Formatters
            nixd
            alejandra
            stylua
            ;
          ## AI context
          apm = customLib.mkUvxBin pkgs "apm" "--from apm-cli apm";
        };
      };
    };
  };
}
