return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local whickey = require("which-key")

		telescope.setup({
			defaults = {
				path_display = { shorten = { len = 4, exclude = { 1, -1 } } },
				mappings = {
					i = {
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						["<C-e>"] = actions.which_key,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		whickey.add({
			{ "<leader>f", group = "File" },
			{ "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor in cwd" },
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Fuzzy find files in cwd" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Fuzzy find recent files" },
			{ "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Find string in cwd" },
			{ "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find todos" },
		})
	end,
}
