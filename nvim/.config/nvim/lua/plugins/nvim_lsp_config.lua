return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"saghen/blink.cmp",
	},
	config = function()
		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local wk = require("which-key")
				wk.add({
					{ "<leader>l", buffer = ev.buf, group = "LSP" },
					{ "<leader>lR", ":LspRestart<CR>", buffer = ev.buf, desc = "Restart LSP" },
					{ "<leader>ld", buffer = ev.buf, group = "Diagnostics" },
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

		-- mason-lspconfig (automatic_enable) handles its ensure_installed servers;
		-- cspell_ls is a custom server (lsp/cspell_ls.lua) installed via mason-tool-installer.
		vim.lsp.enable("cspell_ls")
	end,
}
