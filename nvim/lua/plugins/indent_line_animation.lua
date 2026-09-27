return {
	"echasnovski/mini.indentscope",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("mini.indentscope").setup()
	end,
}