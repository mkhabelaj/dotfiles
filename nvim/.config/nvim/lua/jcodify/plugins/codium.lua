return {
	"Exafunction/codeium.vim",
	event = "BufEnter",
	config = function()
		local wk = require("which-key")
		wk.add({
			mode = { "i" },
			{
				"<M-c>",

				function()
					return vim.fn["codeium#Clear"]()
				end,
				desc = "Clear codeium",
				expr = true,
				replace_keycodes = false,
			},
			{
				"<M-j>",

				function()
					return vim.fn["codeium#CycleCompletions"](1)
				end,
				desc = "Cycle through completions",
				expr = true,
				replace_keycodes = false,
			},
			{
				"<M-k>",
				function()
					return vim.fn["codeium#CycleCompletions"](-1)
				end,
				desc = "Cycle through completions",
				expr = true,
				replace_keycodes = false,
			},
		})
	end,
}
