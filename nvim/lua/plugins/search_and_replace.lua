return {
	"nvim-pack/nvim-spectre",
	cmd = "Spectre",
	keys = {
		{ "<leader>S", desc = "Toggle Spectre" },
		{ "<leader>sp", desc = "Search on current file" },
	},

	-----------------------------------
	-- Dependencies
	-----------------------------------
	dependencies = { "nvim-lua/plenary.nvim" },

	-----------------------------------
	-- Configuration
	-----------------------------------
	config = function()
		require("spectre").setup()

		vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
			desc = "Toggle Spectre",
		})

		vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
			desc = "Search on current file",
		})
	end,
}
