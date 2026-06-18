return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      auto_install = true,
        ensure_installed = { "markdown", "markdown_inline", "r", "rnoweb", "yaml", "csv", "python" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}
