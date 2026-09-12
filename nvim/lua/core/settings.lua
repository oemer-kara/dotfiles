-----------------------------------------------------------
-- Performance Optimizations
-----------------------------------------------------------
vim.opt.synmaxcol = 200 -- Limit syntax highlighting to first 200 columns to improve performance in large files

-----------------------------------------------------------
-- Line Numbers and Display Settings
-----------------------------------------------------------
vim.opt.number = true -- Show absolute line numbers on the left
vim.opt.relativenumber = true -- Show relative line numbers for easier vertical navigation
vim.opt.cursorline = true -- Highlight the current line for better visibility
vim.opt.signcolumn = "yes" -- Always show sign column to prevent shifting
vim.opt.numberwidth = 5 -- Fixed width number column to prevent shifting on mode change
vim.opt.showmode = false -- Stops showing the modes
-- vim.opt.colorcolumn = "80"     -- Display vertical line at column 80 for code length guidance

-----------------------------------------------------------
-- Search and Replace Behavior
-----------------------------------------------------------
vim.opt.ignorecase = true -- Make searches case-insensitive by default
vim.opt.smartcase = true -- Override ignorecase if search pattern contains uppercase
vim.opt.incsearch = true -- Show search matches as you type
vim.opt.hlsearch = false -- Don't highlight all matches after search is complete
vim.opt.gdefault = true -- Apply substitutions globally on lines by default
vim.opt.inccommand = "nosplit" -- Show preview of substitutions in real-time

-----------------------------------------------------------
-- Editor Behavior
-----------------------------------------------------------
vim.opt.mouse = "a" -- Enable mouse support in all modes
vim.opt.clipboard = "unnamedplus" -- Use system clipboard for all operations
vim.opt.scrolloff = 10 -- Keep 10 lines visible above/below cursor when scrolling
vim.opt.sidescrolloff = 8 -- Keep 10 columns visible when scrolling horizontally
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false -- Use tabs for indentation

-----------------------------------------------------------
-- Folding
-----------------------------------------------------------
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false -- Start with folds open
vim.opt.foldlevel = 99 -- High fold level to start with all folds open

-----------------------------------------------------------
-- Window Management
-----------------------------------------------------------
vim.opt.splitright = true -- Open vertical splits to the right
vim.opt.splitbelow = true -- Open horizontal splits below
vim.opt.equalalways = true -- Keep windows equal size when splitting

-----------------------------------------------------------
-- History and Session Management
-----------------------------------------------------------
vim.opt.history = 10000 -- Remember more commands and search history
vim.opt.undolevels = 10000 -- Maximum number of changes that can be undone

-----------------------------------------------------------
-- Global Leader Key Settings
-----------------------------------------------------------
vim.g.mapleader = " " -- Set Space as the leader key for custom mappings
vim.g.maplocalleader = "," -- Set comma as the local leader for filetype-specific mappings

-----------------------------------------------------------
-- Disable File Explorer
-----------------------------------------------------------
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-----------------------------------------------------------
-- Diagnostic Configuration
-----------------------------------------------------------
vim.diagnostic.config({
	virtual_text = true, -- Show error messages inline
	signs = true, -- Show error signs in the gutter (E, W, etc.)
	underline = true, -- Underline errors
	update_in_insert = false, -- Don't update diagnostics while typing
	severity_sort = true, -- Sort diagnostics by severity
})
