return {
	"lmantw/themify.nvim",
	lazy = false,
	priority = 999,

	config = {
		"folke/tokyonight.nvim",
		"sho-87/kanagawa-paper.nvim",
		"catppuccin/nvim",
		"rose-pine/neovim",
	},

	keys = {
		{
			"<leader>tt",
			"<cmd>Themify<CR>",
			desc = "Toggle theme",
		},
	},
}
