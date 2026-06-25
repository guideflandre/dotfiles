return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" , "r_language_server", "pyright", "ts_ls", "eslint", "tailwindcss" }
      })
    end
  },
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.config("lspconfig", {})
            vim.lsp.enable({"lspconfig"})

            -- Suppress spurious INVALID_SERVER_MESSAGE errors from r_language_server
            -- caused by rlang version conflict (loaded < required)
            local orig_notify = vim.notify
            vim.notify = function(msg, level, opts)
                if type(msg) == "string"
                    and msg:find("INVALID_SERVER_MESSAGE", 1, true)
                    and msg:find("r_language_server", 1, true) then
                    return
                end
                orig_notify(msg, level, opts)
            end

            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {desc = "Hover definition"})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {desc = "Show definition"})
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {desc = "Show code actions"})
        end
    }
}


