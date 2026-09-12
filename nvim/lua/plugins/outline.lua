return {
	"hedyhli/outline.nvim",
	cmd = "Outline",
	keys = {
		{ "<leader>o", "<cmd>Outline<cr>", desc = "Toggle code outline" },
	},
	opts = {
		outline_window = {
			position = "right",
			width = 25,
		},
		symbols = {
			icon_source = "lspkind",
		},
	},
}
