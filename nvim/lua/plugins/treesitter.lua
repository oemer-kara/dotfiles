return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- "main" is the rewritten branch that dropped the .configs module this
		-- config relies on (ensure_installed/highlight.enable/indent.enable/
		-- incremental_selection/fold). "master" keeps the classic API.
		branch = "master",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"python",
					"c",
					"cpp",
					"cmake",
					"lua",
					"tcl",
					"markdown",
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = "<C-s>",
						node_decremental = "<C-backspace>",
					},
				},
				fold = {
					enable = true,
				},
			})
		end,
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
		},
		priority = 100,
	},
}
