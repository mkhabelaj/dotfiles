return {
	"David-Kunz/gen.nvim",
	keys = {
		{
			"<leader>agg",
			":Gen<CR>",
			desc = "Command dropdown",
			mode = { "n", "v" },
		},
		{
			"<leader>age",
			":Gen Enhance_Grammar_Spelling<CR>",
			desc = "Enhance Grammar Spellig",
			mode = "v",
		},
		{
			"<leader>agw",
			":Gen Enhance_Wording<CR>",
			desc = "Enhance Wording",
			mode = "v",
		},
		{ "<leader>agc", ":Gen Make_Concise<CR>", desc = "Make Concise", mode = "v" },
		{ "<leader>agl", ":Gen Make_List<CR>", desc = "Make List", mode = "v" },
		{ "<leader>agt", ":Gen Make_Table<CR>", desc = "Make Table", mode = "v" },
		{
			"<leader>agr",
			":Gen Review_Code<CR>",
			desc = "Review Code",
			mode = "v",
		},
		{
			"<leader>ags",
			":Gen Summarize<CR>",
			desc = "Summarize",
			mode = "v",
		},
		{
			"<leader>agm",
			function()
				require("gen").select_model()
			end,
			desc = "Change Model",
			mode = { "n", "v" },
		},
	},
	opts = {
		model = "deepseek-r1",
	},
}
