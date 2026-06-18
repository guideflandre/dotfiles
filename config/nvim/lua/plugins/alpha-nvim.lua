return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-mini/mini.icons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Custom header
		dashboard.section.header.val = {
			"                                           ",
			"        ██████╗██████╗ ██╗ ██████╗         ",
			"       ██╔════╝██╔══██╗██║██╔═══██╗        ",
			"       ██║     ██████╔╝██║██║   ██║        ",
			"       ██║     ██╔══██╗██║██║   ██║        ",
			"       ╚██████╗██████╔╝██║╚██████╔╝        ",
			"        ╚═════╝╚═════╝ ╚═╝ ╚═════╝         ",
			"                                           ",
			"            Guillaume Deflandre            ",
			"                                           ",
		}

		-- Custom buttons
		dashboard.section.buttons.val = {
			dashboard.button("e", "󰈔  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("SPC f f", "󰈞  Find file", ":Telescope find_files <CR>"),
			dashboard.button("SPC f o", "󰊄  Recently opened files", ":Telescope oldfiles <CR>"),
			dashboard.button("SPC f g", "󰈬  Find word", ":Telescope live_grep <CR>"),
			dashboard.button("SPC f m", "󰃀  Jump to bookmarks", ":lua _G.open_bookmarks()<CR>"),
			dashboard.button("q", "󰩈  Quit", ":qa<CR>"),
		}

		alpha.setup(dashboard.config)

		-- Bookmark functionality
		local bookmarks = {
			{
				name = "config",
				path = "/home/guillaumedeflandre/.config",
			},
			{
				name = "RforMS",
				path = "/home/guillaumedeflandre/Documents/" .. "drive_UCL/PHD/rformassspectrometry",
			},
			{
				name = "PSMatch",
				path = "/home/guillaumedeflandre/Documents/"
					.. "drive_UCL/PHD/rformassspectrometry/"
					.. "PSMatch-oriented/PSMatch",
			},
			{
				name = "PTMods",
				path = "/home/guillaumedeflandre/Documents/"
					.. "drive_UCL/PHD/rformassspectrometry/"
					.. "PTMods-oriented/PTMods",
			},
		}

		_G.open_bookmarks = function()
			local options = {}
			for _, bookmark in ipairs(bookmarks) do
				table.insert(options, bookmark.name)
			end

			vim.ui.select(options, {
				prompt = "Select bookmark:",
			}, function(choice)
				if choice then
					for _, bookmark in ipairs(bookmarks) do
						if bookmark.name == choice then
							vim.cmd("cd " .. bookmark.path)
							vim.cmd("Telescope find_files")
							break
						end
					end
				end
			end)
		end

		vim.keymap.set("n", "<leader>fm", _G.open_bookmarks, { desc = "Open bookmarks" })
	end,
}
