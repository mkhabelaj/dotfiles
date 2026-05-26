return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local caps = require("cmp_nvim_lsp").default_capabilities()

		vim.lsp.config["lua_ls"] = {
			capabilities = caps,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					completion = { callSnippet = "Replace" },
				},
			},
		}
		vim.lsp.config["basedpyright"] = {
			-- before_init = require("venv-selector").python,
			capabilities = caps,
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "workspace",
						typeCheckingMode = "off",
						autoImportCompletions = true,
					},
				},
			},
		}

		vim.lsp.config("cspell_ls", {
			cmd = { "cspell-lsp", "--stdio" },
			root_markers = { ".git", "pyproject.toml", "package.json" },
			filetypes = {
				"python",
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
				"lua",
				"html",
				"css",
				"json",
				"markdown",
				"gitcommit",
			},
			single_file_support = true,
		})

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
					{ "K", vim.lsp.buf.hover, buffer = ev.buf, desc = "Hover docs" },
					{ "gl", "<cmd>Lspsaga peek_definition<CR>", buffer = ev.buf, desc = "Peek definition" },
					{ "gF", "<cmd>Lspsaga finder<CR>", buffer = ev.buf, desc = "References" },
					{
						"gd",
						function()
							Snacks.picker.lsp_definitions()
						end,
						buffer = ev.buf,
						desc = "Goto Definition",
					},
					{
						"gD",
						function()
							Snacks.picker.lsp_declarations()
						end,
						buffer = ev.buf,
						desc = "Goto Declaration",
					},
					{
						"gr",
						function()
							Snacks.picker.lsp_references()
						end,
						nowait = true,
						buffer = ev.buf,
						desc = "References",
					},
					{
						"gI",
						function()
							Snacks.picker.lsp_implementations()
						end,
						buffer = ev.buf,
						desc = "Goto Implementation",
					},
					{
						"gy",
						function()
							Snacks.picker.lsp_type_definitions()
						end,
						buffer = ev.buf,
						desc = "Goto T[y]pe Definition",
					},
				})
			end,
		})

		vim.lsp.enable("lua_ls")
		vim.lsp.enable("basedpyright")
		vim.lsp.enable("vtsls")
		vim.lsp.enable("cssls")
		vim.lsp.enable("html")
		vim.lsp.enable("cspell_ls")
		vim.lsp.enable("jsonls")
		vim.lsp.enable("tailwindcss")
		vim.lsp.enable("emmet_ls")
	end,
}
