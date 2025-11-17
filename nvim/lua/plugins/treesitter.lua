return {
  "nvim-treesitter/nvim-treesitter", 
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      auto_install = true,
        ensure_installed = { "markdown", "markdown_inline", "r", "rnoweb", "yaml", "csv" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}

