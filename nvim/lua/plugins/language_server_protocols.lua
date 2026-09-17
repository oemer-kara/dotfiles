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
		local mason_tool_installer = require("mason-tool-installer")
		local none_ls = require("null-ls")
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

		vim.lsp.config("clangd", {
			cmd = clangd_cmd,
			capabilities = capabilities,
			offset_encoding = "utf-16",
			root_markers = {
				".clangd",
				".clang-tidy",
				".clang-format",
				"compile_commands.json",
				"compile_flags.txt",
				"configure.ac",
				".git",
			},
			on_attach = on_attach,
		})

		-- Python LSP configuration
		vim.lsp.config("pyright", {
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- LaTeX LSP configuration
		vim.lsp.config("texlab", {
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- CMake LSP configuration
		vim.lsp.config("neocmake", {
			-- neocmakelsp >=0.10 uses the `stdio` subcommand, not `--stdio`
			-- (lspconfig's default cmd is `--stdio`, which fails to start the server)
			cmd = { "neocmakelsp", "stdio" },
			capabilities = capabilities,
			filetypes = { "cmake" },
			root_markers = { "CMakeLists.txt", ".git" },
			init_options = {
				format = { enable = true },
				lint = { enable = true },
				scan_cmake_in_package = true,
			},
			on_attach = on_attach,
		})

		-- GitLab CI LSP configuration
		-- gitlab_ci_ls only attaches to the "yaml.gitlab" filetype, so detect
		-- GitLab CI yaml files and tag them accordingly.
		vim.filetype.add({
			filename = {
				[".gitlab-ci.yml"] = "yaml.gitlab",
				[".gitlab-ci.yaml"] = "yaml.gitlab",
			},
			pattern = {
				[".*%.gitlab%-ci%.ya?ml"] = "yaml.gitlab",
				[".*/%.gitlab/.*%.ya?ml"] = "yaml.gitlab",
				[".*/%.gitlab%-ci/.*%.ya?ml"] = "yaml.gitlab",
			},
		})

		vim.lsp.config("gitlab_ci_ls", {
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- YAML LSP configuration (schema validation, incl. GitLab CI)
		vim.lsp.config("yamlls", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				yaml = {
					schemas = {
						["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = {
							".gitlab-ci.yml",
							".gitlab-ci.yaml",
							".gitlab/*.yml",
							".gitlab-ci/*.yml",
						},
					},
				},
			},
		})

		vim.lsp.enable({ "clangd", "pyright", "texlab", "neocmake", "gitlab_ci_ls", "yamlls" })



		----------------------------------------
		-- TOOL INSTALLER SETUP
		----------------------------------------
		mason_tool_installer.setup({
			ensure_installed = {
				-- LSP servers
				"neocmakelsp",
				"gitlab-ci-ls",
				"yaml-language-server",
				-- Formatters
				-- "clang-format", -- Disabled: using system clang-format instead
				-- "google-java-format", -- Commented out until needed
				-- "latexindent", -- Commented out until needed
				-- Linters
				"yamllint",
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
				none_ls.builtins.diagnostics.yamllint.with({
					filetypes = { "yaml", "yaml.gitlab" },
					-- relaxed preset with new-lines disabled: this is a Windows repo (CRLF),
					-- and yamllint's LF-only check isn't relevant here
					extra_args = { "-d", "{extends: relaxed, rules: {new-lines: disable}}" },
					prepend_extra_args = true,
				}),
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
