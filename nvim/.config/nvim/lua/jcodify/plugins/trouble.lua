return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
	config = function()
		local wk = require("which-key")
		wk.add({
			{ "<leader>ldt", group = "Trouble" },
			{
				"<leader>ldtd",
				"<cmd>TroubleToggle document_diagnostics<CR>",
				desc = "Open trouble document diagnostics",
			},
			{ "<leader>ldtl", "<cmd>TroubleToggle loclist<CR>", desc = "Open trouble location list" },
			{ "<leader>ldtq", "<cmd>TroubleToggle quickfix<CR>", desc = "Open trouble quickfix list" },
			{ "<leader>ldtt", "<cmd>TodoTrouble<CR>", desc = "Open todos in trouble" },
			{
				"<leader>ldtw",
				"<cmd>TroubleToggle workspace_diagnostics<CR>",
				desc = "Open trouble workspace diagnostics",
			},
		})
		require("trouble").setup()
	end,
}
