return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- "main" is the rewritten branch that dropped the .configs module this
		-- config relies on (ensure_installed/highlight.enable/indent.enable/
		-- incremental_selection/fold). "master" keeps the classic API.
		branch = "master",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSUpdate", "TSInstall", "TSInstallInfo", "TSModuleInfo" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"python",
					"c",
					"cpp",
					"cmake",
					"lua",
					"tcl",
					"markdown",
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = "<C-s>",
						node_decremental = "<C-backspace>",
					},
				},
				fold = {
					enable = true,
				},
			})

			-- nvim-treesitter (master) ships a markdown injections query that
			-- uses the (#set-lang-from-info-string! @_lang) directive. Its
			-- handler in nvim-treesitter/query_predicates.lua reads
			-- `match[capture_id]` as a single TSNode, but Neovim 0.12 passes
			-- every capture as a TSNode[] list. The handler therefore feeds a
			-- table to vim.treesitter.get_node_text() and every fenced code
			-- block with an info string (```cpp, ```lua, ...) throws
			--   treesitter.lua:197: attempt to call method 'range' (a nil value)
			-- which render-markdown.nvim then re-raises on each redraw.
			--
			-- An after/queries/ override does not help: get_files() takes the
			-- FIRST non-`; extends` file on the runtimepath as the base, and
			-- the plugin's copy precedes after/. query.set() skips file lookup
			-- altogether, so it wins. The text below is Neovim 0.12's bundled
			-- markdown/injections.scm, which captures the language node
			-- directly and needs no directive.
			vim.treesitter.query.set(
				"markdown",
				"injections",
				[[
(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)

((html_block) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))

((minus_metadata) @injection.content
  (#set! injection.language "yaml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

((plus_metadata) @injection.content
  (#set! injection.language "toml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

([
  (inline)
  (pipe_table_cell)
] @injection.content
  (#set! injection.language "markdown_inline"))
]]
			)

			-- The bundled query uses the info string as the parser name
			-- verbatim, while nvim-treesitter's directive mapped common
			-- aliases. Re-register the ones worth keeping.
			for alias, parser in pairs({
				["c++"] = "cpp",
				["h"] = "c",
				["hpp"] = "cpp",
				["sh"] = "bash",
				["shell"] = "bash",
				["zsh"] = "bash",
				["js"] = "javascript",
				["ts"] = "typescript",
				["py"] = "python",
				["yml"] = "yaml",
				["md"] = "markdown",
				["rs"] = "rust",
				["cmake"] = "cmake",
			}) do
				pcall(vim.treesitter.language.register, parser, alias)
			end
		end,
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
		},
		priority = 100,
	},
}
