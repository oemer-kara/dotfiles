return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"meuter/lualine-so-fancy.nvim",
		"nvim-tree/nvim-web-devicons", -- Ensure you have this for icons
	},
	enabled = true,
	lazy = false,
	config = function()
		----------------------------------------
		-- LUALINE SETUP
		----------------------------------------
		require("lualine").setup({
			----------------------------------------
			-- GLOBAL OPTIONS
			----------------------------------------
			options = {
				globalstatus = true,
				icons_enabled = true,
				component_separators = { left = "|", right = "|" }, -- Simple separators
				section_separators = { left = "", right = "" }, -- No section separators for a cleaner look
				disabled_filetypes = {
					statusline = {
						"alpha-nvim",
						"help",
						"neo-tree",
						"Trouble",
						"spectre_panel",
					},
					winbar = {},
				},
			},

			----------------------------------------
			-- ACTIVE STATUSLINE SECTIONS
			----------------------------------------
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							return str:sub(1, 1) -- Simplify mode display
						end,
					},
				},
				lualine_b = {
					"branch", -- Simple branch display
					"diff",
				},
				lualine_c = {
					{
						"filename",
						path = 1, -- 2 for full path
						fmt = function(str)
							if str:match("toggleterm") then
								return " Terminal" -- Use a terminal icon
							end
							return str
						end,
						symbols = {
							modified = "  ", -- A more modern modified symbol
							readonly = "  ",
							unnamed = "  ",
						},
					},
					{
						"fancy_diagnostics",
						sources = { "nvim_lsp" },
						symbols = { error = " ", warn = " ", info = " " },
					},
					{ "fancy_searchcount" },
				},
				lualine_x = {
					{
						function()
							local reg = vim.fn.reg_recording()
							if reg ~= "" then
								return "Recording @" .. reg
							end
							return ""
						end,
					},
					"encoding",
					"fileformat",
					{
						"filetype",
						icons_enabled = true,
						icon = { align = "right" }, -- Align filetype icon to the right
					},
				},
				lualine_y = {
					"location",
					{
						"progress",
						fmt = function(str)
							return str -- Simplify progress display
						end,
					},
				},
				lualine_z = {
					function()
						return os.date("%H:%M") -- Simplify date and time display
					end,
				},
			},

			----------------------------------------
			-- INACTIVE STATUSLINE SECTIONS
			----------------------------------------
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},

			----------------------------------------
			-- EXTENSIONS & TABLINE
			----------------------------------------
			tabline = {},
			extensions = { "neo-tree", "lazy" },
		})
	end,
}
