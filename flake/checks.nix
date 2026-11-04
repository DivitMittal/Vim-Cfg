{inputs, ...}: {
  imports = [inputs.git-hooks.flakeModule];

  perSystem = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.pre-commit.settings;
    git = lib.getExe cfg.gitPackage;
    prek = lib.getExe cfg.package;
    ## Same derivation as git-hooks.nix's internal `install_stages`: every git hook type that
    ## some enabled hook runs at (e.g. pre-push for check-added-large-files)
    hookTypes = lib.pipe cfg.hooks [
      (lib.filterAttrs (_: h: h.enable))
      (lib.mapAttrsToList (_: h: h.stages))
      lib.concatLists
      (map (s:
        if lib.elem s ["commit" "merge-commit" "push"]
        then "pre-${s}"
        else s))
      (lib.remove "manual")
      lib.unique
    ];
  in {
    ## Replaces git-hooks.nix's installer (disabled via `install.enable` below), which can't work
    ## here: it sets `core.hooksPath ""` before `prek install`, and prek >= 0.3.11 refuses that
    ## ("hooks directory resolved to ."), so no hooks ever got installed. It then pins hooksPath
    ## to ".git/hooks" relative to the checkout, which doesn't exist in a linked worktree
    ## (.worktrees/*, where `.git` is a file), so git silently skips hooks there.
    ## Instead: leave hooksPath unset so git uses the shared $GIT_COMMON_DIR/hooks, and install
    ## those against a config link inside the common dir, so every worktree runs the same hooks
    ## without needing its own gitignored .pre-commit-config.yaml.
    devshells.default.devshell.startup.git-hooks.text = ''
      if wc=$(${git} rev-parse --show-toplevel 2>/dev/null) \
        && common_dir=$(${git} rev-parse --path-format=absolute --git-common-dir); then
        shared_config="$common_dir/pre-commit-config.json"

        ## Points $1 at the generated config (a GC root, so a gc can't break the hooks)
        __link_precommit_config() {
          [ "$(readlink "$1")" = "${cfg.configFile}" ] && return 0
          if [ -e "$1" ] && [ ! -L "$1" ]; then
            echo 1>&2 "git-hooks: refusing to replace non-symlink $1; remove it to get Nix-managed hooks"
            return 1
          fi
          rm -f "$1"
          ${
        if cfg.addGcRoot
        then ''nix-store --add-root "$1" --indirect --realise ${cfg.configFile} >/dev/null''
        else ''ln -s ${cfg.configFile} "$1"''
      }
        }
        ## The checkout-root link is what a manual `prek run` reads
        __link_precommit_config "$wc/${cfg.configPath}"

        if ${git} config --local --get core.hooksPath >/dev/null; then
          ${git} config --local --unset-all core.hooksPath
        fi
        if __link_precommit_config "$shared_config"; then
          for hook in ${lib.escapeShellArgs hookTypes}; do
            if ! grep -qF -- "--config=\"$shared_config\"" "$common_dir/hooks/$hook" 2>/dev/null; then
              ${prek} install -f -c "$shared_config" -t "$hook"
            fi
          done
        fi
        unset -f __link_precommit_config
      fi
    '';

    pre-commit = {
      check.enable = true;

      settings = {
        enable = true;
        ## Installation is done by the `git-hooks` devshell startup entry above
        install.enable = false;
        package = pkgs.prek;
        gitPackage = pkgs.gitFull;
        src = ../.;
        excludes = ["flake.lock"];
        default_stages = ["pre-commit"];
        hooks = {
          ## Formatting
          treefmt.enable = false;
          trim-trailing-whitespace.enable = true;
          mixed-line-endings.enable = false;

          check-added-large-files = {
            enable = true;
            excludes = [
              ## Images
              "\\.png"
              "\\.jpg"
              "\\.jpeg"
              "\\.svg"
              "\\.gif"
            ];
          };
          check-case-conflicts.enable = true;
          check-executables-have-shebangs.enable = true;
          check-shebang-scripts-are-executable.enable = true;

          fix-byte-order-marker.enable = true;
          check-merge-conflicts.enable = true;
          detect-private-keys.enable = true;
        };
      };
    };
  };
}
