return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
	},
	opts = {
		workspaces = {
			{
				name = "Writing",
				path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Writing",
			},
		},
		picker = {
			-- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
			name = "telescope.nvim",
			-- Optional, configure key mappings for the picker. These are the defaults.
			-- Not all pickers support all mappings.
			note_mappings = {
				-- Create a new note from your query.
				new = "<C-x>",
				-- Insert a link to the selected note.
				insert_link = "<C-l>",
			},
			tag_mappings = {
				-- Add tag(s) to current note.
				tag_note = "<C-x>",
				-- Insert a tag at the current location.
				insert_tag = "<C-l>",
			},
		},
		ui = {
			enable = false,
		},
		mappings = {
			-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true, desc = "Follow markdown/wiki link" },
			},
			-- Toggle check-boxes.
			["<leader>om"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true, desc = "Toggle checkbox" },
			},
			-- Smart action depending on context, either follow link or toggle checkbox.
			["<leader>os"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true, desc = "Follow link or toggle checkbox" },
			},
			-- Search notes
			["<leader>so"] = {
				action = function()
					return ":ObsidianSearch<CR>"
				end,
				opts = { buffer = true, expr = true, desc = "Obsidian search" },
			},
			-- Open Obsidian app
			["<leader>oa"] = {
				action = function()
					return ":ObsidianOpen<CR>"
				end,
				opts = { buffer = true, expr = true, desc = "Open Obsidian app" },
			},
			-- :ObsidianFollowLink hsplit
			["<leader>of"] = {
				action = function()
					return ":ObsidianFollowLink vsplit<CR>"
				end,
				opts = { buffer = true, expr = true, desc = "Follow link in new vsplit" },
			},
			-- :ObsidianBacklinks
			["<leader>ob"] = {
				action = function()
					return ":ObsidianBacklinks<CR>"
				end,
				opts = { buffer = true, expr = true, desc = "Show backlinks" },
			},
			-- :ObsidianPasteImg
			["<leader>op"] = {
				action = function()
					return ":ObsidianPasteImg<CR>"
				end,
				opts = { buffer = true, expr = true, desc = "Paste image" },
			},
			-- :ObsidianQuickSwitch
			["<leader>oq"] = {
				action = function()
					return ":ObsidianQuickSwitch<CR>"
				end,
				opts = { buffer = true, expr = true, desc = "Quick switch" },
			},
		},
	},
}
