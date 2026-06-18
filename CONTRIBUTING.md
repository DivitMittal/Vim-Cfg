# Contributing

Contributions are welcome — bug reports, fixes, and improvements to the Neovim/Vim configuration.

## Setup

```sh
nix develop   # enter dev shell (nixd, alejandra, stylua)
```

## Guidelines

- **Nix files**: format with `alejandra` (enforced by pre-commit)
- **Lua files**: format with `stylua` (enforced by pre-commit)
- **LaTeX files**: format with `latexindent` (enforced by pre-commit)
- Run `nix flake check` before submitting — CI runs the same check
- Test changes with an actual Neovim/Vim instance before submitting

## Submitting Changes

1. Fork the repo and create a branch: `feat/description` or `fix/description`
2. Keep commits atomic; use [Conventional Commits](https://www.conventionalcommits.org/) format
3. Open a PR against `main` with a clear description of what and why

## Reporting Issues

Open a GitHub issue with:
- Your platform (macOS/Linux), nixpkgs channel, and Neovim/Vim version
- Steps to reproduce
- Expected vs actual behavior
