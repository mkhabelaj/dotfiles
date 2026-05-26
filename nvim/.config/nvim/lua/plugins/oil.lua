return {
	"stevearc/oil.nvim",
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	lazy = false,
	opts = {
		default_file_explorer = true,
	},
	keys = {
		{
			"<leader>oc",
			function()
				require("oil").close()
			end,
			desc = "Close Oil Explorer",
		},
		{ "<leader>oo", "<cmd>Oil<CR>", desc = "Open Oil Explorer" },
	},
}
