return {
	"nvimdev/lspsaga.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("lspsaga").setup({
			ui = {
				border_style = "round",
				code_action = "",
			},
		})
	end,
}
