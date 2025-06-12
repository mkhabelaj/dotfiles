-- ~/.config/nvim/lua/plugins/mason.lua
return {
	{
		"williamboman/mason.nvim",
		event = { "BufReadPre", "BufNewFile" },
		cmd = "Mason",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "folke/neodev.nvim", opts = {} },
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		config = function(_, opts)
			-- 1) Mason core
			require("mason").setup(opts)

			-- 2) Extra CLI tools
			require("mason-tool-installer").setup({
				ensure_installed = {
					"prettier",
					"stylua",
					"isort",
					"black",
					"ruff",
					"eslint_d",
					"phpcs",
					"php-cs-fixer",
					"stylelint",
					"goimports-reviser",
					"gofumpt",
					"golines",
					"delve",
				},
			})

			-- 3) LSP servers + handlers
			local mlsp = require("mason-lspconfig")
			local lspcfg = require("lspconfig")
			local caps = require("cmp_nvim_lsp").default_capabilities()

			-- Generic loader: look for `plugins.lsp.servers/<server>.lua`
			local function setup(server)
				local ok, server_opts = pcall(require, "plugins.lsp.servers." .. server)
				if not ok or type(server_opts) ~= "table" then
					server_opts = {}
				end
				server_opts.capabilities = server_opts.capabilities or caps
				lspcfg[server].setup(server_opts)
			end

			mlsp.setup({
				ensure_installed = {
					"ts_ls",
					"html",
					"cssls",
					"tailwindcss",
					"lua_ls",
					"emmet_ls",
					"pyright",
					"jsonls",
					"intelephense",
					"gopls",
					"vue_ls",
					"prismals",
				},
				-- automatic_enable is true by default
				handlers = {
					-- default for *all* servers
					setup,
					-- if you ever need a server-specific override, you can add:
					-- tsserver = function() ... end,
					-- volar    = function() ... end,
				},
			})

			-- 4) Buffer-local LSP keymaps on attach
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local wk = require("which-key")
					wk.add({
						{ "<leader>l", buffer = ev.buf, group = "LSP" },
						{ "<leader>lR", ":LspRestart<CR>", buffer = ev.buf, desc = "Restart LSP" },
						{ "<leader>ld", buffer = ev.buf, group = "Diagnostics" },
						{ "<leader>ldj", vim.diagnostic.goto_next, buffer = ev.buf, desc = "Next diagnostic" },
						{ "<leader>ldk", vim.diagnostic.goto_prev, buffer = ev.buf, desc = "Prev diagnostic" },
						{ "<leader>ldl", vim.diagnostic.open_float, buffer = ev.buf, desc = "Line diagnostics" },
						{ "<leader>ll", vim.diagnostic.open_float, buffer = ev.buf, desc = "Line diagnostics" },
						{ "<leader>lo", "<cmd>Lspsaga outline<CR>", buffer = ev.buf, desc = "Outline" },
						{ "<leader>lr", vim.lsp.buf.rename, buffer = ev.buf, desc = "Rename" },
						{
							mode = { "n", "v" },
							{ "<leader>la", vim.lsp.buf.code_action, buffer = ev.buf, desc = "Code action" },
						},
					})
					wk.add({
						{ "gl", "<cmd>Lspsaga peek_definition<CR>", buffer = ev.buf, desc = "Peek definition" },
						{ "gF", "<cmd>Lspsaga finder<CR>", buffer = ev.buf, desc = "References" },
						{ "K", vim.lsp.buf.hover, buffer = ev.buf, desc = "Hover docs" },
					})
				end,
			})
		end,
	},
}
