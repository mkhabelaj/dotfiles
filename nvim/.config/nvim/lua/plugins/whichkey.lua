return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		preset = "modern",
		show_help = true,
		show_keys = true,
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		wk.add({
			-- ╭─────────────────────────────────────────────────────────╮
			-- │ Core Group Definitions                                  │
			-- ╰─────────────────────────────────────────────────────────╯
			{ "<leader>b", group = "Buffer" },
			{ "<leader>c", group = "Code" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>ld", group = "Diagnostics" },
			{ "<leader>o", group = "Oil Explorer" },
			{ "<leader>s", group = "Search" },
			{ "<leader>t", group = "Theme" },
			{ "<leader>T", group = "Todo Comments" },
			{ "<leader>u", group = "UI/Toggle" },
			{ "<leader>v", group = "Window" },
			{ "<leader>w", group = "Workspace" },
			-- ╭─────────────────────────────────────────────────────────╮
			-- │ General Utilities                                       │
			-- ╰─────────────────────────────────────────────────────────╯
			{ "<leader>q", "<cmd>q<CR>", desc = "Quit window" },
			{ "<leader>\\", "<cmd>nohl<CR>", desc = "Clear highlights" },
			-- ╭─────────────────────────────────────────────────────────╮
			-- │ Window Management                                       │
			-- ╰─────────────────────────────────────────────────────────╯
			{ "<leader>ve", "<C-w>=", desc = "Equalize splits" },
			{ "<leader>vh", "<C-w>s", desc = "Split horizontally" },
			{ "<leader>vv", "<C-w>v", desc = "Split vertically" },
			{ "<leader>vx", "<cmd>close<CR>", desc = "Close split" },
		})
	end,
}
