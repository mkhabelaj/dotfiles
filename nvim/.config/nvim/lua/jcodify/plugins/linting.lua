return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		local phpcs = require("lint").linters.phpcs

		local which_key = require("which-key")

		phpcs.args = {
			"-q",
			-- <- Add a new parameter here
			"--standard=PSR12",
			"--report=json",
			"-",
		}

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			php = { "php", "phpcs" },
			css = { "stylelint" },
			scss = { "stylelint" },
			-- python = { "ruff" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		which_key.add({
			{
				"<leader>wl",
				function()
					lint.try_lint()
				end,
				desc = "Trigger linting for current file",
			},
		})
	end,
}
