return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")
		local wk = require("which-key")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				svelte = { "prettierd" },
				solid = { "prettierd" },
				css = { "prettierd" },
				html = { "prettierd" },
				json = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
				graphql = { "prettierd" },
				liquid = { "prettierd" },
				lua = { "stylua" },
				python = { "black" },
			},
			formatters = {
				black = {
					command = "black",
					args = { "--line-length", "160", "-" },
				},
			},
			format_on_save = {
				lsp_format = "fallback",
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
						lsp_format = "fallback",
						async = false,
						timeout_ms = 1000,
					})
				end,
				desc = "Format file or range (in visual mode)",
			},
		})
	end,
}
