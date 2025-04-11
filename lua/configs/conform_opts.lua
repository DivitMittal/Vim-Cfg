return {
  formatters_by_ft = {
    lua = { "stylua" },

    -- c/cpp
    c = { "clang-format" },
    cpp = { "clang-format" },

    -- prettier
    html = { "prettier" },
    css = { "prettier" },
    javascript = { "prettier" },
    markdown = { "prettier" },
    yaml = { "prettier" },
    json = { "prettier" },
    typescript = { "prettier" },

    python = { "black" },
    nix = { "alejandra" },
    kdl = { "kdlfmt" },

    -- shell
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },
    fish = { "fish_indent" },

    -- haskell
    haskell = { "stylish-haskell" },
    lhaskell = { "stylish-haskell" },
    cabal = { "cabal_fmt" },
  },
}
