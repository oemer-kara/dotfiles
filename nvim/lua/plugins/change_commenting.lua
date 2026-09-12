return {
	"numToStr/Comment.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		----------------------------------------
		-- COMMENT MAPPINGS
		----------------------------------------
		mappings = {
			basic = true,
			extra = true,
		},
	},
	config = function(_, opts)
		----------------------------------------
		-- PLUGIN SETUP
		----------------------------------------
		require("Comment").setup(opts)

		----------------------------------------
		-- FILETYPE SETTINGS
		----------------------------------------
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "cpp",
			callback = function()
				vim.bo.commentstring = "// %s"
			end,
		})
	end,
}
