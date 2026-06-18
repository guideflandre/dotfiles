vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.wo.relativenumber = true
vim.opt.nu = true
vim.g.mapleader = " "
vim.opt.smartindent = true
vim.o.clipboard = "unnamedplus"

local function hide_diagnostics()
	vim.diagnostic.config({ -- https://neovim.io/doc/user/diagnostic.html
		virtual_text = false,
		signs = false,
		underline = false,
	})
end
local function show_diagnostics()
	vim.diagnostic.config({
		virtual_text = true,
		signs = true,
		underline = true,
	})
end
vim.keymap.set("n", "<leader>dh", hide_diagnostics, { desc = "Hide diagnostics" })
vim.keymap.set("n", "<leader>ds", show_diagnostics, { desc = "Show diagnostics" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.opt.textwidth = 80

-- Ensure auto-wrap at textwidth is never disabled by filetype plugins
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:append("t")
	end,
})
