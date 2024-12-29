return {
	"ThePrimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local wk = require("which-key")
		local harpoon = require("harpoon")
		wk.add({
			{
				mode = { "n", "v" },
				{ "<leader>h", group = "Harpoon" },
				{
					"<leader>hj",
					function()
						require("harpoon.ui").nav_next()
					end,
					desc = "Go to next harpoon mark",
				},
				{
					"<leader>hk",
					function()
						require("harpoon.ui").nav_prev()
					end,
					desc = "Go to previous harpoon mark",
				},
				{
					"<leader>hm",
					function()
						require("harpoon.mark").add_file()
					end,
					desc = "Mark file with harpoon",
				},
				{
					"<leader>hn",
					function()
						require("harpoon.ui").nav_next()
					end,
					desc = "Go to next harpoon mark",
				},
				{
					"<leader>hq",

					function()
						require("harpoon.ui").toggle_quick_menu()
					end,
					desc = "Quick Menu",
				},
				{ "<leader>hs", "<cmd>Telescope harpoon marks<cr>", desc = "Show marks" },
			},
		})
		harpoon.setup()
	end,
}
