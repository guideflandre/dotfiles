return {
	{
		"R-nvim/R.nvim",
		lazy = false,
		config = function()
			require("r").setup({
				R_app = "radian --profile /home/guillaumedeflandre/.config/radian/profile",
				R_cmd = "R",
				auto_quit = true,
				pdfviewer = "evince",
				R_args = { "--no-save", "--no-restore" },
				bracketed_paste = true,
			})

			-- Keymaps for R, Rmd, and Quarto filetypes
			-- LocalLeader is set to "\" by R-nvim convention
			--
			-- Keymap summary:
			--   INSERT mode:
			--     <C-S-m>            → Insert native pipe operator ( |> )
			--
			--   NORMAL mode:
			--     <LocalLeader>kc    → Insert an empty ```{r} ``` code block below cursor (Rmd/Quarto)
			--     <LocalLeader>cf    → Format current file using styler with Bioconductor style guide
			--                          Requires: styler and biocthis packages installed in R
			--                          Equivalent to: styler::style_file(file, style = biocthis::bioc_style())
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "r", "rmd", "quarto" },
				callback = function()
					-- Insert native pipe operator in insert mode
					vim.keymap.set("i", "<C-S-m>", " |> ", {
						buffer = true,
						desc = "Insert pipe operator ( |> )",
					})

					-- Insert an empty R code block below the current line (Rmd/Quarto)
					vim.keymap.set("n", "<LocalLeader>kc", function()
						local line = vim.api.nvim_win_get_cursor(0)[1]
						vim.api.nvim_buf_set_lines(0, line - 1, line - 1, false, {
							"```{r}",
							"",
							"```",
						})
						vim.api.nvim_win_set_cursor(0, { line + 1, 0 })
						vim.cmd("startinsert!")
					end, {
						buffer = true,
						desc = "Insert R code block (```{r} ... ```)",
					})

					-- Format current file using styler with Bioconductor style guide
					-- Requires the following R packages:
					--   install.packages("styler")
					--   BiocManager::install("biocthis")
					vim.keymap.set("n", "<LocalLeader>cf", function()
						local filepath = vim.api.nvim_buf_get_name(0)
						if filepath == "" then
							vim.notify("styler: buffer has no file path — save the file first", vim.log.levels.WARN)
							return
						end
						-- Write any unsaved changes before formatting
						vim.cmd("write")
						local cmd = string.format(
							"Rscript -e \"styler::style_file('%s', style = biocthis::bioc_style())\"",
							filepath
						)
						vim.fn.jobstart(cmd, {
							on_exit = function(_, exit_code)
								if exit_code == 0 then
									-- Reload the buffer to reflect formatted changes on disk
									vim.cmd("edit")
									vim.notify("styler: file formatted with Bioconductor style", vim.log.levels.INFO)
								else
									vim.notify(
										"styler: formatting failed — check R packages are installed",
										vim.log.levels.ERROR
									)
								end
							end,
						})
					end, {
						buffer = true,
						desc = "Format file with styler (Bioconductor style)",
					})
				end,
			})
		end,
	},
}
