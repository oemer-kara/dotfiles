return {
	"mluders/comfy-line-numbers.nvim",
	config = function()
		require("comfy-line-numbers").setup({
			labels = {
				"1",
				"2",
				"3",
				"4",
				"11",
				"12",
				"13",
				"14",
				"21",
				"22",
				"23",
				"24",
				"31",
				"32",
				"33",
				"34",
				"41",
				"42",
				"43",
				"44",
				"111",
				"112",
				"113",
				"114",
				"121",
				"122",
				"123",
				"124",
				"125",
				"131",
				"132",
				"133",
				"134",
				"141",
				"142",
				"143",
				"144",
				"211",
				"212",
				"213",
				"214",
				"221",
				"222",
				"223",
				"224",
				"231",
				"232",
				"233",
				"234",
				"241",
				"242",
				"243",
				"244",
			},
			up_key = "k",
			down_key = "j",
			hidden_file_types = { "undotree" },
			hidden_buffer_types = { "terminal", "nofile" },
		})

		-- Fix: override the plugin's statuscolumn format to remove the %=
		-- flexible alignment items that cause column width to shift on mode change
		local orig_update = _G.update_status_column
		_G.update_status_column = function()
			orig_update()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				if vim.wo[win].statuscolumn ~= "" then
					vim.wo[win].statuscolumn =
						'%s%{v:virtnum > 0 ? "" : v:lua.get_label(v:lnum, v:relnum)} '
				end
			end
		end
		-- Apply immediately
		update_status_column()
	end,
}
