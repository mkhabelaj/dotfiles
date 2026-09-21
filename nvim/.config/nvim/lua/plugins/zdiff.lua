return {
	"martindur/zdiff.nvim",
	cmd = "Zdiff",
	keys = {
		{ "<leader>gz", "<cmd>Zdiff<CR>", desc = "Zdiff (uncommitted)" },
		{ "<leader>gZ", "<cmd>Zdiff main<CR>", desc = "Zdiff (vs main)" },
	},
	opts = {},
}
