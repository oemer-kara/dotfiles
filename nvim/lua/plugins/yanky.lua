return {
	"gbprod/yanky.nvim",
	event = "VeryLazy",
	opts = {},
	keys = {
		{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after" },
		{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before" },
		{ "<C-p>", "<Plug>(YankyPreviousEntry)", desc = "Cycle to previous yank" },
		{ "<C-n>", "<Plug>(YankyNextEntry)", desc = "Cycle to next yank" },
	},
}
