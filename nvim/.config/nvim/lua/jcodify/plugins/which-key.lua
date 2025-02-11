return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {},
	config = function()
		local wk = require("which-key")
		wk.setup()
		wk.add({
			-- { "<leader>", group = "General" },
			-- { "<leader>g", group = "Git" },
			{ "<leader>\\", "<cmd>nohl<CR>", desc = "Clear highlights" },
			{ "<leader>q", "<cmd>q<CR>", desc = "Quit" },
			{ "<leader>v", group = "Window" },
			{ "<leader>ve", "<C-w>=", desc = "Make splits equal size" },
			{ "<leader>vh", "<C-w>s", desc = "Split window horizontally" },
			{ "<leader>vv", "<C-w>v", desc = "Split window vertically" },
			{ "<leader>vx", "<cmd>close<CR>", desc = "Close current split" },
			{ "<leader>w", group = "Workspace" },
			{ "<leader>wQ", "<cmd>qa<CR>", desc = "Quit all" },
			{ "<leader>wW", "<cmd>noa w!<CR>", desc = "Save without autocommands" },
			{ "<leader>ww", "<cmd>w!<CR>", desc = "Format and Save" },
			{ "<leader>wq", "<cmd>q<CR>", desc = "Quit" },
		})
	end,
}
