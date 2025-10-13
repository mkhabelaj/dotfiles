return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			"<leader>ga",
			function()
				require("gitsigns").blame()
			end,
			desc = "Toggle Line Blame (gitsigns)",
		},
		{
			"<leader>gD",
			function()
				require("gitsigns").diffthis()
			end,
			desc = "Git Diff(gitsigns)",
		},
	},
}
