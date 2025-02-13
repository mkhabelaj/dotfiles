return {
	"stevearc/oil.nvim",
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	config = function()
		require("oil").setup({
			default_file_explorer = true,
		})

		local wk = require("which-key")
		wk.add({
			{
				"<leader>oc",
				function()
					require("oil").close()
				end,
				desc = "Close Oil Explorer",
			},
			{ "<leader>oo", "<cmd>Oil<CR>", desc = "Open Oil Explorer" },
		})
	end,
}
