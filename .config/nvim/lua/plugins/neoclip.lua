return {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        { "kkharji/sqlite.lua", module = "sqlite" },
    },
    config = function()
        require("neoclip").setup({
            keys = {
                telescope = {
                    i = {
                        paste_behind = "<cr>",
                        paste = "<c-p>",
                        replay = "<c-q>",
                        delete = "<c-d>",
                        edit = "<c-e>",
                        custom = {},
                    },
                    n = {
                        paste_behind = "<cr>",
                        paste = "p",
                        replay = "q",
                        delete = "d",
                        edit = "e",
                        custom = {},
                    },
                },
            },
            default_register = '"',
        })

        -- Load the telescope extension
        require("telescope").load_extension("neoclip")

        -- Set up keybinding for yank history
        vim.keymap.set("n", "<leader>fy", function()
            require("telescope").extensions.neoclip.default()
        end, { desc = "yank history" })
    end,
}
