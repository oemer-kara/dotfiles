return {
	"j-hui/fidget.nvim",
	event = "LspAttach",
	opts = {
		progress = {
			suppress_on_insert = true,
			display = {
				render_limit = 0,
			},
		},
		notification = {
			window = {
				winblend = 0,
			},
		},
	},
}
