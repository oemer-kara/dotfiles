-----------------------------------------------------------
-- Utility Functions for Keymaps
-----------------------------------------------------------
local function map(mode, lhs, rhs, opts)
	-- Set default options if none provided
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-----------------------------------------------------------
-- Utility
-----------------------------------------------------------
map("n", "vv", "V", { desc = "Select entire line" })
map("v", "<Leader>sr", ":lua VisualBlockSearchReplace()<CR>", { desc = "Search and replace" })
map("n", "<leader>ya", "ggVGy", { desc = "Yank entire buffer" })
map("n", "<leader>da", "ggVGd", { desc = "Delete entire buffer" })
map("i", "<C-h>", "<C-w>", { desc = "Remove word with C-w" })
map("n", "<C-s>", ":w<CR>", { desc = "Save file" })
map("v", "b", "<C-v>", { desc = "Visual block mode" })

-- Functions
function VisualBlockSearchReplace()
	-- Get the visual selection range
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")

	-- Get the search and replace terms
	local search_term = vim.fn.input("Search for: ")
	if search_term == "" then
		return
	end

	local replace_term = vim.fn.input("Replace with: ")
	if replace_term == "" then
		return
	end

	-- Get all the lines in the selection
	local lines = vim.fn.getline(start_line, end_line)

	-- Replace all instances in each line
	for i, line in ipairs(lines) do
		-- Use Vim's substitute so users can use familiar Vim regex patterns
		local patates_line = vim.fn.substitute(line, search_term, replace_term, "g")
		-- Set the modified line back
		vim.fn.setline(start_line + i - 1, patates_line)
	end
end

-----------------------------------------------------------
-- Essential Navigation
-----------------------------------------------------------
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Window resizing
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Right>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Left>", ":vertical resize +2<CR>", { desc = "Increase window width" })
map("n", "<C-+>", ":vertical resize =<CR>", { desc = "Equalize window width" })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next search result and center" })
map("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-----------------------------------------------------------
-- Editing Enhancements
-----------------------------------------------------------
-- Better indenting in visual mode
map("v", "<", "<gv", { desc = "Decrease indent and maintain selection" })
map("v", ">", ">gv", { desc = "Increase indent and maintain selection" })

-----------------------------------------------------------
-- Split Management
-----------------------------------------------------------
-- Split creation
map("n", "<leader>sh", ":split<CR>", { desc = "Horizontal split" })
map("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sc", ":close<CR>", { desc = "Close split" })

-----------------------------------------------------------
-- Buffer Management
-----------------------------------------------------------
map("n", "<C-q>", ":bd!<CR>", { desc = "Close current buffer" })
