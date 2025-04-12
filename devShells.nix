{inputs, ...}: {
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem = {pkgs, ...}: {
    devshells.default = {
      packages = builtins.attrValues {
        inherit(pkgs)
          stylua
        ;
      };
    };
  };
}