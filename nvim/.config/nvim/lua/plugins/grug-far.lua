return {
	"MagicDuck/grug-far.nvim",
	cmd = { "GrugFar", "GrugFarWithin" },
	keys = {
		{ "<leader>sr", "<cmd>GrugFar<CR>", desc = "Search & Replace (grug-far)" },
		{ "<leader>sr", ":GrugFar<CR>", mode = "v", desc = "Search & Replace selection (grug-far)" },
	},
	opts = {},
}
