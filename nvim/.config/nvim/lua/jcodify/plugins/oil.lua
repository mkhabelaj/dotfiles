return {
	"stevearc/oil.nvim",
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	config = function()
		require("oil").setup({
			default_file_explorer = false,
		})

		local wk = require("which-key")
		wk.add({
			{ "<leader>o", group = "Oil Explorer" },
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
