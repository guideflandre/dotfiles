return {
    "lukas-reineke/virt-column.nvim",
    lazy = false,
    config = function()
        require("virt-column").setup({
            char = "│",  -- Thin vertical line character
            virtcolumn = "80",
        })

        -- Set the colour to grey
        vim.api.nvim_set_hl(0, "VirtColumn", { fg = "#3a3a3a" })
    end
}
