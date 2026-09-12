return {
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	opts = {
		input = {
			enabled = true,
			default_prompt = "> ",
			border = "rounded",
			relative = "cursor",
		},
		select = {
			enabled = true,
			backend = { "telescope", "builtin" },
		},
	},
}
