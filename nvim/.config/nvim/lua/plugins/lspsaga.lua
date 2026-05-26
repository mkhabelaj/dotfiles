return {
	"nvimdev/lspsaga.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"neovim/nvim-lspconfig", -- We only want this loaded when using nvim-lspconfig
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
