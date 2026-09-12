return {
	"kevinhwang91/nvim-hlslens",
	event = "VeryLazy",
	opts = {},
	keys = {
		{ "n", [[<Cmd>execute("normal! " . v:count1 . "n")<CR><Cmd>lua require("hlslens").start()<CR>zz]], desc = "Next match" },
		{ "N", [[<Cmd>execute("normal! " . v:count1 . "N")<CR><Cmd>lua require("hlslens").start()<CR>zz]], desc = "Prev match" },
		{ "*", [[*<Cmd>lua require("hlslens").start()<CR>]], desc = "Search word forward" },
		{ "#", [[#<Cmd>lua require("hlslens").start()<CR>]], desc = "Search word backward" },
	},
}
