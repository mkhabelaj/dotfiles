return {
	"FabijanZulj/blame.nvim",
	cmd = "BlameToggle",
	keys = {
		{ "<leader>ga", "<cmd>BlameToggle<CR>", desc = "Toggle File Blame (blame.nvim)" },
	},
	opts = {
		date_format = "%r",
		-- show a commit once for runs of lines it owns
		merge_consecutive = true,
	},
}
