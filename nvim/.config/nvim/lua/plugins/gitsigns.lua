return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		-- off by default; toggle with <leader>gi
		current_line_blame = false,
		current_line_blame_opts = {
			delay = 300,
		},
		current_line_blame_formatter = "<author>, <author_time:%R> • <summary>",
	},
	keys = {
		{
			"<leader>gi",
			function()
				require("gitsigns").toggle_current_line_blame()
			end,
			desc = "Toggle Inline Blame (gitsigns)",
		},
		{
			"<leader>gD",
			function()
				require("gitsigns").diffthis()
			end,
			desc = "Git Diff(gitsigns)",
		},
		{
			"]h",
			function()
				require("gitsigns").nav_hunk("next")
			end,
			desc = "Next git hunk (gitsigns)",
		},
		{
			"[h",
			function()
				require("gitsigns").nav_hunk("prev")
			end,
			desc = "Prev git hunk (gitsigns)",
		},
	},
}
