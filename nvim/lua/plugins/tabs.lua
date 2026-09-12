return {
	"echasnovski/mini.tabline",
	version = "*",
	config = function()
		----------------------------------------
		-- MINI.TABLINE SETUP
		----------------------------------------
		require("mini.tabline").setup({
			show_icons = true,
			tabpage_section = "right",
		})

		----------------------------------------
		-- CUSTOM HIGHLIGHTS FOR ACTIVE TAB
		----------------------------------------
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = function()
				-- Make active tab more prominent
				vim.api.nvim_set_hl(0, "MiniTablineCurrent", {
					fg = "#ffffff",      -- Bright white text
					bg = "#d98e2b",      -- Darker background
					bold = true,         -- Bold text
					italic = false,
				})

				-- Make inactive tabs more subtle
				vim.api.nvim_set_hl(0, "MiniTablineHidden", {
					fg = "#6b7280",      -- Dim gray text
					bg = "#1f2937",      -- Dark background
				})

                -- Visible but not current tabs
				vim.api.nvim_set_hl(0, "MiniTablineVisible", {
					fg = "#9ca3af",      -- Medium gray
					bg = "#374151",      -- Medium dark background
				})

				-- Modified indicator
				vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", {
					fg = "#ffffff",      -- Red for modified
					bg = "#ef4444",
					bold = true,
				})

				-- Modified indicator
				vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", {
					fg = "#ffffff",      -- Red for modified
					bg = "#8c311c",
					bold = true,
				})
			end,
		})

		-- Trigger the highlight setup immediately
		vim.cmd("doautocmd ColorScheme")

		----------------------------------------
		-- KEY MAPPINGS
		----------------------------------------
		vim.keymap.set("n", "<A-.>", "<cmd>bnext<CR>", { desc = "Next tab" }) -- Switch to next tab
		vim.keymap.set("n", "<A-,>", "<cmd>bprevious<CR>", { desc = "Previous tab" }) -- Switch to previous tab
	end,
}
