return {
	"folke/todo-comments.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{
			"<leader>Tj",
			function()
				todo_comments.jump_next()
			end,
			desc = "Next todo comment",
		},
		{
			"<leader>Tk",
			function()
				todo_comments.jump_prev()
			end,
			desc = "Previous todo comment",
		},
		{ "<leader>Tl", "<cmd>TodoLocList<CR>", desc = "List todo comments" },
		{ "<leader>Tq", "<cmd>TodoQuickFix<CR>", desc = "Quickfix todo comments" },
		{ "<leader>Tt", "<cmd>TodoTrouble<CR>", desc = "Open todos in trouble" },
	},
}
