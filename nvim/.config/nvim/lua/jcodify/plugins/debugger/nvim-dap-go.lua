return {
	"leoluz/nvim-dap-go",
	ft = "go",
	dependencies = "mfussenegger/nvim-dap",
	config = function(_, opts)
		require("dap-go").setup(opts)
	end,
	keys = {
		{
			"<leader>dgt",
			function()
				require("dap-go").debug_test()
			end,
			desc = "Debug Go Test",
		},
		{
			"<leader>dgl",
			function()
				require("dap-go").debug_last()
			end,
			desc = "Debug Go Last",
		},
	},
}
