return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},

	keys = {
		{ "<leader>aC", "<cmd>CodeCompanionChat<CR>", desc = "Code companion chat" },
	},
	opts = {
		strategies = {
			chat = { adapter = "ollama" },
			inline = { adapter = "ollama" },
		},
		adapters = {
			ollama_deepseek_r1 = function()
				return require("codecompanion.adapters").extend("ollama", {
					schema = {
						model = {
							default = "deepseek-r1:latest",
						},
					},
				})
			end,
		},
	},
}
