-- Plugin specification for codecompanion.nvim
return {
	"olimorris/codecompanion.nvim", -- Main plugin repository

	-- Required dependencies for the plugin to function
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},

	-- Key mappings for plugin commands
	keys = {
		{ "<leader>aC", "<cmd>CodeCompanionChat<CR>", desc = "Code companion chat" },
	},

	-- Plugin options and configuration
	opts = {
		strategies = {
			-- Chat strategy configuration
			chat = {
				adapter = "copilot", -- Use Copilot as the backend
				model = "claude-3-5-sonnet", -- Model for chat
			},
			-- Inline strategy configuration
			inline = {
				adapter = "copilot",
				keymaps = { -- Key mappings for inline actions
					reject_change = {
						modes = { n = "gk" }, -- 'gk' in normal mode rejects suggestion
						description = "Reject the suggested change",
					},
				},
			},
		},
		adapters = {
			-- Custom adapter for DeepSeek R1 model via Ollama
			ollama_deepseek_r1 = function()
				return require("codecompanion.adapters").extend("ollama", {
					schema = {
						model = {
							default = "deepseek_r1:8b",
						},
					},
				})
			end,
			-- Custom adapter for Mistral model via Ollama
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
