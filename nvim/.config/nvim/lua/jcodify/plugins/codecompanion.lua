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
			chat = {
				adapter = "copilot",
				model = "claude-3-5-sonnet",
			},
			inline = {
				adapter = "copilot",
			},
		},
		adapters = {
			ollama_deepseek_r1 = function()
				return require("codecompanion.adapters").extend("ollama", {
					schema = {
						model = {
							default = "deepseek_r1:8b",
						},
					},
				})
			end,
			ollama_mistral = function()
				return require("codecompanion.adapters").extend("ollama", {
					schema = {
						model = {
							default = "mistral:latest",
						},
					},
				})
			end,
		},
	},
}
