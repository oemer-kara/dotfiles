return {
	"williamboman/mason.nvim",
	version = "~1.8.0",
	dependencies = {
		{ "williamboman/mason-lspconfig.nvim", version = "~1.20.0" },
		{ "whoissethdaniel/mason-tool-installer.nvim", version = "~1.11.0" },
		{ "nvimtools/none-ls.nvim", version = "~1.0.0" },
		"nvim-lua/plenary.nvim",
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"onsails/lspkind.nvim",
	},
	config = function()
		----------------------------------------
		-- IMPORTS
		----------------------------------------
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")
		local none_ls = require("null-ls")
		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local telescope = require("telescope.builtin")
		local lspkind = require("lspkind")

		-- Add position encoding support for LSP
		capabilities.offsetEncoding = { "utf-16", "utf-8" }

		----------------------------------------
		-- MASON CORE SETUP
		----------------------------------------
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		----------------------------------------
		-- LSPKIND CONFIGURATION
		----------------------------------------
		lspkind.init({
			mode = "symbol_text",
			preset = "codicons",
			symbol_map = {
				Text = "󰉿",
				Method = "󰆧",
				Function = "󰊕",
				Constructor = "󰑐",
				Field = "󰜢",
				Variable = "󰀫",
				Class = "󰠱",
				Interface = "󰜰",
				Module = "󰏖",
				Property = "󰜢",
				Unit = "󰑭",
				Value = "󰎠",
				Enum = "󰕘",
				Keyword = "󰌋",
				Snippet = "󰘦",
				Color = "󰏘",
				File = "󰈙",
				Reference = "󰈇",
				Folder = "󰉋",
				EnumMember = "󰕘",
				Constant = "󰏿",
				Struct = "󰙅",
				Event = "󰉁",
				Operator = "󰆕",
				TypeParameter = "󰊄",
			},
		})

		----------------------------------------
		-- LSP CONFIGURATIONS
		----------------------------------------
		local on_attach = function(client, bufnr)
			local opts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set("n", "gd", telescope.lsp_definitions, opts)
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "gi", telescope.lsp_implementations, opts)
			vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "gr", telescope.lsp_references, opts)
		end

		-- C/C++ LSP configuration
		local clangd_cmd = {
			"clangd",
			"--header-insertion=never",
			"--all-scopes-completion",
		}

		-- Add platform-specific options
		local os_name = vim.uv.os_uname().sysname
		if os_name == "Windows_NT" then
			-- Windows-specific clangd configuration
			table.insert(clangd_cmd, "--query-driver=**/mingw64/bin/gcc.exe,**/mingw64/bin/g++.exe")
			table.insert(clangd_cmd, "--offset-encoding=utf-16")
		else
			-- Linux/macOS configuration
			table.insert(clangd_cmd, "--offset-encoding=utf-8")
		end

		lspconfig.clangd.setup({
			cmd = clangd_cmd,
			capabilities = capabilities,
			offset_encoding = "utf-16",
			root_dir = lspconfig.util.root_pattern(
				".clangd",
				".clang-tidy",
				".clang-format",
				"compile_commands.json",
				"compile_flags.txt",
				"configure.ac",
				".git"
			),
			on_attach = on_attach,
		})

		-- Python LSP configuration
		lspconfig.pyright.setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- LaTeX LSP configuration
		lspconfig.texlab.setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- CMake LSP configuration
		lspconfig.neocmake.setup({
			-- neocmakelsp >=0.10 uses the `stdio` subcommand, not `--stdio`
			-- (lspconfig's default cmd is `--stdio`, which fails to start the server)
			cmd = { "neocmakelsp", "stdio" },
			capabilities = capabilities,
			filetypes = { "cmake" },
			root_dir = lspconfig.util.root_pattern("CMakeLists.txt", ".git"),
			init_options = {
				format = { enable = true },
				lint = { enable = true },
				scan_cmake_in_package = true,
			},
			single_file_support = true,
			on_attach = on_attach,
		})



		----------------------------------------
		-- TOOL INSTALLER SETUP
		----------------------------------------
		mason_tool_installer.setup({
			ensure_installed = {
				-- LSP servers
				"neocmakelsp",
				-- Formatters
				-- "clang-format", -- Disabled: using system clang-format instead
				-- "google-java-format", -- Commented out until needed
				-- "latexindent", -- Commented out until needed
				-- Linters
				-- "ruff", -- Commented out until needed
			},
		})

		----------------------------------------
		-- NONE-LS SETUP
		----------------------------------------
		none_ls.setup({
			sources = {
				-- FORMATTERS
				none_ls.builtins.formatting.clang_format.with({
					extra_args = { "--style=file" },
				}),
				none_ls.builtins.formatting.black,
				-- LINTERS
				-- none_ls.builtins.diagnostics.ruff, -- Commented out until installed
			},
		})

		----------------------------------------
		-- AUTO FORMATTING
		----------------------------------------
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function()
				-- Only format if an LSP client with formatting capability is attached
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				for _, client in ipairs(clients) do
					if client:supports_method("textDocument/formatting") then
						vim.lsp.buf.format({ async = false })
						return
					end
				end
			end,
		})
	end,
}
