return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")
		wk.setup({
			preset = "modern",
			delay = 300,
			icons = {
				breadcrumb = "»",
				separator = "➜",
				group = "+ ",
			},
			win = {
				border = "rounded",
				padding = { 1, 2 },
			},
		})

		wk.add({
			-----------------------------------
			-- Groups
			-----------------------------------
			{ "<leader>f", group = "Find (Telescope)" },
			{ "<leader>g", group = "Git" },
			{ "<leader>s", group = "Split/Search" },

			-----------------------------------
			-- Utility
			-----------------------------------
			{ "<C-s>", desc = "Save file" },
			{ "<C-q>", desc = "Close buffer" },
			{ "vv", desc = "Select entire line" },
			{ "<leader>ya", desc = "Yank entire buffer" },
			{ "<leader>da", desc = "Delete entire buffer" },
			{ "<leader>S", desc = "Toggle Spectre (search/replace)" },
			{ "<leader>sp", desc = "Spectre: search current file" },
			{ "<leader>sr", desc = "Visual search & replace", mode = "v" },
			{ "<leader>k", desc = "Signature help (LSP)" },
			{ "<leader>rn", desc = "Rename symbol (LSP)" },

			-----------------------------------
			-- Navigation
			-----------------------------------
			{ "<C-h>", desc = "Move to left window" },
			{ "<C-j>", desc = "Move to lower window" },
			{ "<C-k>", desc = "Move to upper window" },
			{ "<C-l>", desc = "Move to right window" },
			{ "<C-d>", desc = "Scroll down (centered)" },
			{ "<C-u>", desc = "Scroll up (centered)" },

			-----------------------------------
			-- Window Resizing
			-----------------------------------
			{ "<C-Up>", desc = "Increase window height" },
			{ "<C-Down>", desc = "Decrease window height" },
			{ "<C-Left>", desc = "Increase window width" },
			{ "<C-Right>", desc = "Decrease window width" },

			-----------------------------------
			-- Splits
			-----------------------------------
			{ "<leader>sh", desc = "Horizontal split" },
			{ "<leader>sv", desc = "Vertical split" },
			{ "<leader>sc", desc = "Close split" },

			-----------------------------------
			-- Tabs (Buffers)
			-----------------------------------
			{ "<A-.>", desc = "Next tab" },
			{ "<A-,>", desc = "Previous tab" },

			-----------------------------------
			-- Telescope (Find)
			-----------------------------------
			{ "<C-t>", desc = "Find files" },
			{ "<C-f>", desc = "Live grep" },
			{ "<leader>fg", desc = "Live grep" },
			{ "<leader>fb", desc = "Find buffers" },
			{ "<leader>fh", desc = "Help tags" },
			{ "<leader>fr", desc = "Find references (LSP)" },

			-----------------------------------
			-- File Explorer
			-----------------------------------
			{ "<C-e>", desc = "Float file explorer" },

			-----------------------------------
			-- LSP
			-----------------------------------
			{ "gd", desc = "Go to definition" },
			{ "gD", desc = "Go to declaration" },
			{ "gi", desc = "Go to implementation" },
			{ "gr", desc = "Go to references" },
			{ "K", desc = "Hover documentation" },

			-----------------------------------
			-- Git
			-----------------------------------
			{ "<leader>gg", desc = "Open Lazygit" },
			{ "<leader>gb", desc = "Blame line" },
			{ "<leader>gB", desc = "Toggle line blame" },
			{ "<leader>gs", desc = "Stage hunk" },
			{ "<leader>gr", desc = "Reset hunk" },
			{ "<leader>gS", desc = "Stage buffer" },
			{ "<leader>gu", desc = "Undo stage hunk" },
			{ "<leader>gR", desc = "Reset buffer" },
			{ "<leader>gp", desc = "Preview hunk" },
			{ "<leader>gd", desc = "Diff this" },
			{ "<leader>gD", desc = "Diff against last commit" },
			{ "]h", desc = "Next git hunk" },
			{ "[h", desc = "Previous git hunk" },

			-----------------------------------
			-- Terminal
			-----------------------------------
			{ "<C-\\>", desc = "Toggle terminal" },

			-----------------------------------
			-- Leap
			-----------------------------------
			{ "q", desc = "Leap (jump anywhere)" },

			-----------------------------------
			-- Theme
			-----------------------------------
			{ "<leader>tt", desc = "Theme switcher" },

			-----------------------------------
			-- Surround (mini.surround)
			-----------------------------------
			{ "sa", desc = "Add surrounding" },
			{ "sd", desc = "Delete surrounding" },
			{ "sc", desc = "Replace surrounding" },

			-----------------------------------
			-- Comment (Comment.nvim)
			-----------------------------------
			{ "gcc", desc = "Toggle line comment" },
			{ "gbc", desc = "Toggle block comment" },
			{ "gc", desc = "Toggle comment", mode = "v" },
			{ "gb", desc = "Toggle block comment", mode = "v" },

			-----------------------------------
			-- Visual Mode
			-----------------------------------
			{ "<", desc = "Indent left (keep selection)", mode = "v" },
			{ ">", desc = "Indent right (keep selection)", mode = "v" },
			{ "b", desc = "Visual block mode", mode = "v" },
		})
	end,
}
