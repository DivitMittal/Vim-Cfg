# Security Policy

## Scope

This repo contains Vim/Neovim configuration (NvChad-based Lua + vimscript) deployed via Nix flakes. The relevant attack surface includes:

- **Lua/vimscript** executed with full user permissions — unsafe plugin configs or arbitrary command execution via editor hooks
- **Nix module options** that install config files into the user's home directory
- **Plugin configurations** that could enable unsafe features (e.g. auto-execution of modelines, unsafe LSP configurations)

## Reporting a Vulnerability

If you find a security issue (e.g. a config that enables modeline execution, or a Lua snippet that could execute untrusted code):

1. Open a **GitHub issue** with the label `security`.
2. Include a description, reproduction steps, and impact assessment.

## Out of Scope

- Issues in upstream Neovim, NvChad, or nixpkgs (report upstream)

## Supported Versions

Only the latest commit on `main` is supported.
