return {
	"nvimdev/lspsaga.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	cmd = "Lspsaga",
	config = function()
		require("lspsaga").setup({
			ui = {
				border_style = "round",
				code_action = "",
			},
		})
	end,
}
