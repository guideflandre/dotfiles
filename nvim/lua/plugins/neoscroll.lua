return {
	"karb94/neoscroll.nvim",
	lazy = false,
	config = function()
		require("neoscroll").setup({
			duration_multiplier = 0.7,
			cursor_scrolls_alone = false,
		})
	end,
}
