vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	-- epwalsh/obsidian.nvim (the originally-famous plugin) is effectively
	-- unmaintained; obsidian-nvim/obsidian.nvim is the actively maintained
	-- fork with an identical require("obsidian") API.
	{ src = "https://github.com/obsidian-nvim/obsidian.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/lmantw/themify.nvim" },
})

require("nvim-treesitter").install({ "markdown", "markdown_inline", "yaml" })

require("mini.icons").setup()

require("render-markdown").setup({
	preset = "obsidian", -- mimic Obsidian's own markdown UI (headers/checkboxes/wikilinks)
	file_types = { "markdown" },
})

-- Obsidian.nvim ---------------------------------------------------------
-- PLACEHOLDER vault path — NOT a real vault. Change WORKSPACE_PATH once
-- you've picked/created your actual notes vault; nothing else below needs
-- editing.
local WORKSPACE_PATH = vim.fn.expand("~/vaults")

-- obsidian.nvim silently drops a workspace whose path doesn't exist at
-- setup() time (logs a warning and skips it — no startup error, but every
-- :Obsidian command then fails with "no active workspace", with no clue
-- why). Since this is just a placeholder directory (not the real vault),
-- pre-create it and the daily/templates subfolders so the workspace
-- actually registers on first boot.
for _, sub in ipairs({ "", "daily", "templates" }) do
	local dir = WORKSPACE_PATH .. (sub ~= "" and ("/" .. sub) or "")
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end
end

require("obsidian").setup({
	legacy_commands = false, -- use `:Obsidian <subcommand>`, not `:ObsidianNew` etc.
	workspaces = {
		{ name = "notes", path = WORKSPACE_PATH },
	},
	completion = {
		-- Completion is driven by obsidian.nvim's own in-process LSP (no
		-- nvim-cmp/blink.cmp needed) — native popups enabled generically
		-- in core/lsp.lua's LspAttach hook.
		min_chars = 2,
	},
	daily_notes = {
		folder = "daily", -- resolved relative to the workspace path
	},
	templates = {
		folder = "templates",
	},
	picker = {
		name = "snacks.picker", -- provided by folke/snacks.nvim, set up below
	},
	ui = {
		enable = false, -- render-markdown.nvim (preset="obsidian" above) owns all rendering
	},
})

require("snacks").setup({
	picker = { enabled = true },
	notifier = { enabled = true, timeout = 3000 },
	input = { enabled = true },
	dashboard = {
		enabled = true,
		preset = {
			header = table.concat({
				"    ___  ___    ___         _               ",
				"   / _ \\/ _ \\  / _ \\___ ___(_)__ _    __    ",
				"  / ___/ , _/ / , _/ -_) V / / -_) |/|/ /   ",
				" /_/  /_/|_| /_/|_|\\__/\\_/_/\\__/|__,__/    ",
				"",
				"          nvim-notes · writing & vault         ",
			}, "\n"),
			keys = {
				{ icon = " ", key = "n", desc = "New note", action = ":Obsidian new" },
				{ icon = " ", key = "t", desc = "Today's daily note", action = ":Obsidian today" },
				{ icon = " ", key = "f", desc = "Find/switch note", action = ":Obsidian quick_switch" },
				{ icon = " ", key = "s", desc = "Search notes", action = ":Obsidian search" },
				{ icon = " ", key = "z", desc = "Zen mode", action = function() Snacks.zen() end },
				{ icon = " ", key = "T", desc = "Theme", action = ":Themify" },
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			},
		},
		-- No "startup" section: it needs lazy.stats, which doesn't exist under vim.pack.
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
		},
	},
	zen = {
		toggles = { dim = true, spell = false, wrap = true }, -- keep wrap on; that's the point here
		win = { style = "zen" },
	},
})

vim.keymap.set("n", "<leader>zz", function()
	Snacks.zen()
end, { desc = "Zen mode" })
vim.keymap.set("n", "<leader>zZ", function()
	Snacks.zen.zoom()
end, { desc = "Zen zoom (current window only)" })

-- themify: same fresh-install guard pattern as nvim-octo, with a "paper"
-- default suited to a writing config (same 4 candidate colorschemes).
-- get_current/set_current/Manager/Event live in themify.api, not the setup module.
local themify = require("themify")
themify.setup({
	"folke/tokyonight.nvim",
	"sho-87/kanagawa-paper.nvim",
	"catppuccin/nvim",
	"rose-pine/neovim",
})
local themify_api = require("themify.api")
if themify_api.get_current() == vim.NIL then
	local DEFAULT_ID, DEFAULT_THEME = "sho-87/kanagawa-paper.nvim", "kanagawa-paper-ink"
	if themify_api.Manager.get(DEFAULT_ID).status == "installed" then
		themify_api.set_current(DEFAULT_ID, DEFAULT_THEME)
	else
		-- install completion fires in a fast event context (libuv callback);
		-- defer so load_theme's option reads are legal.
		themify_api.Event.listen("colorscheme-installed", function(id)
			if id == DEFAULT_ID then
				vim.schedule(function()
					themify_api.set_current(DEFAULT_ID, DEFAULT_THEME)
				end)
			end
		end)
		themify_api.Manager.install() -- clones all not_installed; applies default on finish
	end
end

local wk = require("which-key")
wk.setup({
	preset = "modern",
	show_help = true,
	show_keys = true,
})

wk.add({
	{ "<leader>t", group = "Theme" },
	{ "<leader>tt", "<cmd>Themify<cr>", desc = "Toggle theme" },
	{ "<leader>z", group = "Zen" },
	{ "<leader>u", group = "UI/Toggle" },
	{ "<leader>n", group = "Notes" },
	{ "<leader>nn", "<cmd>Obsidian new<cr>", desc = "New note" },
	{ "<leader>nt", "<cmd>Obsidian today<cr>", desc = "Today's daily note" },
	{ "<leader>nf", "<cmd>Obsidian quick_switch<cr>", desc = "Find/switch note" },
	{ "<leader>ns", "<cmd>Obsidian search<cr>", desc = "Search notes" },
	{ "<leader>nb", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
	{ "<leader>nl", "<cmd>Obsidian follow_link<cr>", desc = "Follow link under cursor" },
	{ "<leader>nT", "<cmd>Obsidian template<cr>", desc = "Insert template" },
})
