vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/lmantw/themify.nvim" },
	{ src = "https://github.com/pwntester/octo.nvim" },
})

-- themify self-installs the listed colorschemes (git) into its data dir.
-- Run :Themify install once after first launch, then :Themify to pick.
-- Set up before octo so the colorscheme applies even if octo.setup errors
-- (e.g. gh missing) — octo highlights need an active theme to look right.
local themify = require("themify")
themify.setup({
	"folke/tokyonight.nvim",
	"sho-87/kanagawa-paper.nvim",
	"catppuccin/nvim",
	"rose-pine/neovim",
})
-- Apply a default only when nothing is picked yet; a :Themify choice persists
-- in themify/state.json and takes over on next launch.
-- get_current/set_current live in themify.api, not the setup module.
local themify_api = require("themify.api")
if themify_api.get_current() == vim.NIL then
	themify_api.set_current("folke/tokyonight.nvim", "tokyonight")
end

require("snacks").setup({})
require("octo").setup({ picker = "snacks" })

local wk = require("which-key")
wk.setup({
	preset = "modern",
	show_help = true,
	show_keys = true,
})

wk.add({
	{ "<leader>t", group = "Theme" },
	{ "<leader>tt", "<cmd>Themify<cr>", desc = "Toggle theme" },
	{ "<leader>r", group = "Review" },
	-- PR launchers
	{ "<leader>l", "<cmd>Octo pr list<cr>", desc = "PR list" },
	{ "<leader>s", "<cmd>Octo pr search<cr>", desc = "PR search" },
	{ "<leader>o", "<cmd>Octo pr browser<cr>", desc = "Open PR in browser" },
	{ "<leader>d", "<cmd>Octo pr diff<cr>", desc = "PR diff" },
	{ "<leader>c", "<cmd>Octo pr checkout<cr>", desc = "PR checkout (branch locally)" },
	{ "<leader>a", "<cmd>Octo actions<cr>", desc = "Octo actions (all commands)" },
	{ "<leader>R", "<cmd>Octo pr reload<cr>", desc = "PR reload" },
	{ "<leader>e", "<cmd>Octo pr edit<cr>", desc = "PR edit (by number)" },
	-- Review flow
	{ "<leader>rs", "<cmd>Octo review start<cr>", desc = "Review start" },
	{ "<leader>rr", "<cmd>Octo review resume<cr>", desc = "Review resume" },
	{ "<leader>rc", "<cmd>Octo review submit<cr>", desc = "Review submit (commit)" },
	{ "<leader>rx", "<cmd>Octo review discard<cr>", desc = "Review discard" },
})
