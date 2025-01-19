return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local wk = require("which-key")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				solid = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
				php = { "php-cs-fixer" },
				go = { "gofumpt", "golines", "goimports-reviser" },
			},
			formatters = {
				["php-cs-fixer"] = {
					command = "php-cs-fixer",
					args = {
						"fix",
						"--rules=@PSR12", -- Formatting preset. Other presets are available, see the php-cs-fixer docs.
						"$FILENAME",
					},
					stdin = false,
				},
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
			notify_on_error = true,
		})

		wk.add({
			{
				mode = { "n", "v" },
				"<leader>lwf",
				function()
					conform.format({
						lsp_fallback = true,
						async = false,
						timeout_ms = 1000,
					})
				end,
				desc = "Format file or range (in visual mode)",
			},
		})
	end,
}
