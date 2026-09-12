return {
	"s1n7ax/nvim-window-picker",
	version = "2.*",
	event = "VeryLazy",
	opts = {
		hint = "floating-big-letter",
		filter_rules = {
			include_current_win = false,
			bo = {
				filetype = { "NvimTree", "neo-tree", "notify", "noice" },
				buftype = { "terminal", "quickfix" },
			},
		},
	},
}
