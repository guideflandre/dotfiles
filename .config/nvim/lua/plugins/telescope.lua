return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
				defaults = {
					file_ignore_patterns = { "^.git/", "%.git$" }, -- optional: ignore .git files/folders
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden", -- include hidden files in live_grep
						"--glob",
						"!**/.git/*", -- exclude .git files/folders
					},
				},
			})
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", function()
				builtin.find_files({ hidden = true })
			end, { desc = "find files including hidden" })
			vim.keymap.set("n", "<leader>fg", function()
				builtin.live_grep()
			end, { desc = "grep including hidden" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers,
				{ desc = "find buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags,
				{ desc = "find help" })
			vim.keymap.set("n", "<leader>fo", builtin.oldfiles,
				{ desc = "recently opened files" })
			require("telescope").load_extension("ui-select")
		end,
	},
}
