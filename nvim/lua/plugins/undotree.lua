return {
	"mbbill/undotree",
	keys = {
		{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" },
	},
	config = function()
		vim.g.undotree_DiffCommand = "FC"
	end,
}
