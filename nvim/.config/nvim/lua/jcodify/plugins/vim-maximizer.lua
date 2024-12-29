return {
	"szw/vim-maximizer",
	config = function()
		local wk = require("which-key")
		wk.add({
			{ "<leader>s", group = "Window" },
			{ "<leader>sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" },
		})
	end,
}
