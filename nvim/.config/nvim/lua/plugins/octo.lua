return {
	"pwntester/octo.nvim",
	cmd = "Octo",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/snacks.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		picker = "snacks",
	},
	-- PR-review-focused launchers under <leader>gp (Git -> PR)
	keys = {
		{ "<leader>gpl", "<cmd>Octo pr list<cr>", desc = "PR list" },
		{ "<leader>gpr", "<cmd>Octo review start<cr>", desc = "Review start" },
		{ "<leader>gpR", "<cmd>Octo review resume<cr>", desc = "Review resume" },
		{ "<leader>gps", "<cmd>Octo pr search<cr>", desc = "PR search" },
		{ "<leader>gpc", "<cmd>Octo pr checkout<cr>", desc = "PR checkout" },
		{ "<leader>gpo", "<cmd>Octo pr browser<cr>", desc = "PR in browser" },
	},
}
