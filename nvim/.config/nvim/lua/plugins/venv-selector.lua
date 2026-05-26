-- return {
-- 	"linux-cultist/venv-selector.nvim",
-- 	dependencies = {
-- 		"neovim/nvim-lspconfig",
-- 		"mfussenegger/nvim-dap",
-- 		"mfussenegger/nvim-dap-python", --optional
-- 		{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
-- 	},
-- 	lazy = false,
-- 	---@type venv-selector.Config
-- 	opts = {
-- 		-- Your settings go here
-- 	},
-- 	keys = {
-- 		-- Keymap to open VenvSelector to pick a venv.
-- 		{ "<leader>lpvs", "<cmd>VenvSelect<cr>" },
-- 	},
-- }

return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		{ "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
	},
	ft = "python", -- Load when opening Python files
	keys = {
		-- Keymap to open VenvSelector to pick a venv.
		{ "<leader>lpvs", "<cmd>VenvSelect<cr>" },
	},
	opts = {
		options = {}, -- plugin-wide options
		search = {}, -- custom search definitions
	},
}
