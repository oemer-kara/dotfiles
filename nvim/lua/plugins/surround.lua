return {
	"echasnovski/mini.surround",
	version = false,
	event = "VeryLazy",
	opts = {
		-----------------------------------
		-- { Mappings Configuration }
		-----------------------------------
		mappings = {
			add = "sa", -- Add surrounding
			delete = "sd", -- Delete surrounding
			replace = "sc", -- Replace surrounding
			update_n_lines = "", -- Update `n_lines`
			suffix_last = "l", -- Suffix to search backward
			suffix_next = "n", -- Suffix to search forward
		},

		-----------------------------------
		-- Additional Options
		-----------------------------------
		search_method = "cover_or_next",
		highlight_duration = 1000,
	},
}
