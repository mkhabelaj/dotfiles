-- Must be set before vim-tmux-navigator loads so it doesn't bind its own
-- <C-h/j/k/l> and clobber the nav() maps below.
vim.g.tmux_navigator_no_mappings = 1

vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/lmantw/themify.nvim" },
	{ src = "https://github.com/christoomey/vim-tmux-navigator" },
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

-- Ctrl-h/j/k/l pane navigation across nvim splits + tmux + herdr.
--   inside tmux  -> vim-tmux-navigator (uses $TMUX)
--   inside herdr -> move nvim split; at edge hand off to `herdr pane focus`
--   plain nvim   -> just wincmd
local function nav(dir, wincmd, tmux_cmd)
	return function()
		if vim.env.TMUX then
			vim.cmd(tmux_cmd)
		elseif vim.env.HERDR_PANE_ID then
			local cur = vim.api.nvim_get_current_win()
			vim.cmd("wincmd " .. wincmd)
			if cur == vim.api.nvim_get_current_win() then
				vim.system({ "herdr", "pane", "focus", "--direction", dir, "--pane", vim.env.HERDR_PANE_ID })
			end
		else
			vim.cmd("wincmd " .. wincmd)
		end
	end
end
vim.keymap.set("n", "<c-h>", nav("left", "h", "TmuxNavigateLeft"), { desc = "Nav left (nvim/tmux/herdr)" })
vim.keymap.set("n", "<c-j>", nav("down", "j", "TmuxNavigateDown"), { desc = "Nav down (nvim/tmux/herdr)" })
vim.keymap.set("n", "<c-k>", nav("up", "k", "TmuxNavigateUp"), { desc = "Nav up (nvim/tmux/herdr)" })
vim.keymap.set("n", "<c-l>", nav("right", "l", "TmuxNavigateRight"), { desc = "Nav right (nvim/tmux/herdr)" })
vim.keymap.set("n", "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", { desc = "Nav previous" })

-- Jump diff hunks in octo review diffs. octo shadows ]c/[c with comment-nav,
-- but the windows are real diff-mode, so `normal! ]c` bypasses the remap.
vim.keymap.set("n", "]h", function()
	if vim.wo.diff then vim.cmd("normal! ]c") end
end, { desc = "Next diff hunk" })
vim.keymap.set("n", "[h", function()
	if vim.wo.diff then vim.cmd("normal! [c") end
end, { desc = "Prev diff hunk" })

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

-- Last: octo.setup shells out to `gh` and errors if it's missing. Keeping it at
-- the end means everything above still loads on a box without gh.
require("octo").setup({ picker = "snacks" })
