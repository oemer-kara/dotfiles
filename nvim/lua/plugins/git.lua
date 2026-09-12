return {
	-----------------------------------
	-- Gitsigns (blame, gutter signs, hunk actions)
	-----------------------------------
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("gitsigns").setup({
				signs = {
					add          = { text = "│" },
					change       = { text = "│" },
					delete       = { text = "_" },
					topdelete    = { text = "‾" },
					changedelete = { text = "~" },
					untracked    = { text = "┆" },
				},
				signs_staged_enable = true,
				current_line_blame = false,
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol",
					delay = 300,
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local function bmap(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation between hunks
					bmap("n", "]h", gs.next_hunk, { desc = "Next git hunk" })
					bmap("n", "[h", gs.prev_hunk, { desc = "Previous git hunk" })

					-- Hunk actions
					bmap("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
					bmap("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
					bmap("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage selected hunk" })
					bmap("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset selected hunk" })
					bmap("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
					bmap("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
					bmap("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
					bmap("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
					bmap("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
					bmap("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
					bmap("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
					bmap("n", "<leader>gD", function() gs.diffthis("~") end, { desc = "Diff against last commit" })
				end,
			})
		end,
	},

	-----------------------------------
	-- Lazygit (full git UI via toggleterm)
	-----------------------------------
	{
		"akinsho/toggleterm.nvim",
		keys = {
			{
				"<leader>gg",
				function()
					local Terminal = require("toggleterm.terminal").Terminal
					-- List form, not a concatenated string: it bypasses the shell, so
					-- paths containing spaces work. The string form split on the first
					-- space, which breaks on any "C:\Users\First Last\..." path.
					local git_root =
						vim.fn.system({ "git", "-C", vim.fn.expand("%:p:h"), "rev-parse", "--show-toplevel" })
					git_root = vim.fn.trim(git_root)

					if vim.v.shell_error ~= 0 then
						vim.notify("Not a git repository", vim.log.levels.WARN)
						return
					end

					local Terminal = require("toggleterm.terminal").Terminal
					local lazygit = Terminal:new({
						cmd = "lazygit",
						hidden = true,
						direction = "float",
						dir = git_root,
						float_opts = { border = "curved" },
						on_open = function(term)
							vim.cmd("startinsert!")
							-- Remove Esc mapping so lazygit can use it
							vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<Esc>", "<Esc>", { noremap = true, silent = true })
						end,
					})
					lazygit:toggle()
				end,
				desc = "Open Lazygit",
			},
		},
	},
}
