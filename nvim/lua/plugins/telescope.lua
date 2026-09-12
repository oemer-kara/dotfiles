return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local open_trouble = require("trouble.sources.telescope").open

		telescope.setup({
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
				},
				prompt_prefix = "   ",
				selection_caret = "  ",
				entry_prefix = "  ",
				multi_icon = " 󰄬 ",
				sorting_strategy = "ascending",
				results_title = false,
				borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				color_devicons = true,
				path_display = { "truncate" },
				winblend = 10,
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = open_trouble,
						["<C-e>"] = actions.smart_send_to_qflist + actions.open_qflist,
						["<Esc>"] = actions.close,
						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,
					},
					n = {
						["q"] = actions.close,
						["<Esc>"] = actions.close,
						["<C-q>"] = open_trouble,
						["<C-e>"] = actions.smart_send_to_qflist + actions.open_qflist,
					},
				},
				file_ignore_patterns = { "node_modules", ".git" },
				layout_strategy = "vertical",
				layout_config = {
					vertical = {
						width = 0.8,
						height = 0.9,
						preview_cutoff = 40,
						prompt_position = "top",
						preview_height = 0.5,
						mirror = true,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					previewer = true,
					prompt_title = " Files",
				},
				live_grep = {
					additional_args = { "--hidden", "-g", "!.git" },
					prompt_title = " Grep",
				},
				buffers = {
					prompt_title = " Buffers",
					sort_mru = true,
					ignore_current_buffer = true,
				},
				help_tags = {
					prompt_title = "󰋖 Help",
				},
				lsp_references = {
					prompt_title = " References",
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		telescope.load_extension("ui-select")

		-- Make the selected entry clearly visible (re-apply on colorscheme change)
		local function set_telescope_hl()
			local hl = vim.api.nvim_set_hl
			hl(0, "TelescopeSelection", { reverse = true, bold = true })
			hl(0, "TelescopeSelectionCaret", { reverse = true, bold = true })
		end
		set_telescope_hl()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = set_telescope_hl })

		-- Key mappings
		local keymap = vim.keymap
		local builtin = require("telescope.builtin")
		keymap.set("n", "<C-t>", builtin.find_files, { desc = "Find files" })
		keymap.set("n", "<C-f>", builtin.live_grep, { desc = "Live grep" })
		keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
		keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
		keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
		keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "Find references" })
	end,
}
