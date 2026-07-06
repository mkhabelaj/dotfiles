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
-- Two separate git repos, each with its own README on the philosophy:
-- personal (~/vaults) and work (~/vaults-work) — deliberately never
-- cloned onto the same machine as each other's context. obsidian.nvim
-- silently skips (with a log warning, no error) any workspace whose path
-- doesn't exist, so whichever repo isn't cloned on a given machine just
-- doesn't show up — no placeholder mkdir needed for either anymore, both
-- are real content.
require("obsidian").setup({
	legacy_commands = false, -- use `:Obsidian <subcommand>`, not `:ObsidianNew` etc.
	workspaces = {
		{ name = "personal", path = vim.fn.expand("~/vault") },
		{ name = "work", path = vim.fn.expand("~/work-vault") },
	},
	-- Flat notes/ pool: every :Obsidian new lands there, not next to
	-- whatever file happens to be open (the default "current_dir" behavior).
	notes_subdir = "notes",
	new_notes_location = "notes_subdir",
	-- YYYY-MM-DD_slug filenames, generated from the title — see the vault's
	-- own README for the philosophy this supports (flat pool + backlinks +
	-- MOCs instead of topic folders).
	note_id_func = function(title)
		local date = os.date("%Y-%m-%d")
		if title and title ~= "" then
			local slug = title:gsub("%s+", "-"):gsub("[^%w%-]", ""):lower()
			return date .. "_" .. slug
		end
		return date .. "_" .. tostring(os.time())
	end,
	completion = {
		-- Completion is driven by obsidian.nvim's own in-process LSP (no
		-- nvim-cmp/blink.cmp needed) — native popups enabled generically
		-- in core/lsp.lua's LspAttach hook.
		min_chars = 2,
	},
	daily_notes = {
		folder = "daily", -- resolved relative to the workspace path
		template = "daily.md",
	},
	templates = {
		folder = "templates",
		date_format = "%Y-%m-%d",
	},
	picker = {
		name = "snacks.picker", -- provided by folke/snacks.nvim, set up below
	},
	ui = {
		enable = false, -- render-markdown.nvim (preset="obsidian" above) owns all rendering
	},
})

-- :Obsidian new's own bare-argument prompt ("Enter id or path (optional):")
-- is obsidian's generic wording and silently falls back to a timestamp
-- filename if left blank. Wrapping it with the same "Note title:" prompt
-- used below keeps both note-creation paths consistent, and simply aborts
-- (like new_note_from_template) instead of ever creating an untitled note.
-- Defined here (before snacks.setup) so the dashboard keys below can use
-- the same functions as the <leader>n* keymaps, not raw :Obsidian commands.
local function new_note()
	vim.ui.input({ prompt = "Note title: " }, function(title)
		if not title or title == "" then
			return
		end
		require("obsidian.actions").new(title, function(note)
			note:open({ sync = true })
		end)
	end)
end

-- :Obsidian template only inserts a template into the CURRENT buffer — it
-- never creates a note, so there's no path from "pick a template" to a
-- properly date_topic-named new file. new_from_template(title, nil, cb)
-- shows the template picker and creates the note with that title, going
-- through the same generate_id/note_id_func pipeline as :Obsidian new, so
-- naming stays consistent automatically.
local function new_note_from_template()
	vim.ui.input({ prompt = "Note title: " }, function(title)
		if not title or title == "" then
			return
		end
		require("obsidian.actions").new_from_template(title, nil, function(note)
			note:open({ sync = true })
		end)
	end)
end

require("snacks").setup({
	picker = { enabled = true },
	notifier = { enabled = true, timeout = 3000 },
	input = { enabled = true },
	dashboard = {
		enabled = true,
		preset = {
			header = table.concat({
				" _  _  ___ _____ ___ ___ ",
				"| \\| |/ _ \\_   _| __/ __|",
				"| .` | (_) || | | _|\\__ \\",
				"|_|\\_|\\___/ |_| |___|___/",
				"",
				"      nvim-notes · writing & vault      ",
			}, "\n"),
			keys = {
				{ icon = " ", key = "n", desc = "New note", action = new_note },
				{ icon = " ", key = "N", desc = "New note from template", action = new_note_from_template },
				{ icon = " ", key = "t", desc = "Today's daily note", action = ":Obsidian today" },
				{ icon = " ", key = "f", desc = "Find/switch note", action = ":Obsidian quick_switch" },
				{ icon = " ", key = "s", desc = "Search notes", action = ":Obsidian search" },
				{
					icon = " ",
					key = "z",
					desc = "Zen mode",
					action = function()
						Snacks.zen()
					end,
				},
				{ icon = " ", key = "w", desc = "Switch vault (personal/work)", action = ":Obsidian workspace" },
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
	-- <leader>ca/<leader>cd are buffer-local, set via LspAttach in
	-- core/lsp.lua (only exist where an LSP client is attached) — just the
	-- group label lives here for which-key discoverability.
	{ "<leader>c", group = "Code/LSP" },
	{ "<leader>n", group = "Notes" },
	{ "<leader>nn", new_note, desc = "New note" },
	{ "<leader>nN", new_note_from_template, desc = "New note from template" },
	{ "<leader>nt", "<cmd>Obsidian today<cr>", desc = "Today's daily note" },
	{ "<leader>nf", "<cmd>Obsidian quick_switch<cr>", desc = "Find/switch note" },
	{ "<leader>ns", "<cmd>Obsidian search<cr>", desc = "Search notes" },
	{ "<leader>nb", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
	{ "<leader>nl", "<cmd>Obsidian follow_link<cr>", desc = "Follow link under cursor" },
	{ "<leader>nT", "<cmd>Obsidian template<cr>", desc = "Insert template" },
	{ "<leader>nw", "<cmd>Obsidian workspace<cr>", desc = "Switch vault (personal/work)" },
	{ "<leader>nc", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Toggle checkbox", mode = { "n", "x" } },
	{ "<leader>np", "<cmd>Obsidian paste_img<cr>", desc = "Paste image from clipboard" },
	{ "<leader>nr", "<cmd>Obsidian rename<cr>", desc = "Rename note (updates references)" },
	{ "<leader>n#", "<cmd>Obsidian tags<cr>", desc = "Browse notes by tag" },
	{ "<leader>no", "<cmd>Obsidian open<cr>", desc = "Open in Obsidian app" },
	{ "<leader>nv", "<cmd>Obsidian toc<cr>", desc = "Table of contents" },
	-- Range commands: pressing `:` from visual mode auto-prepends '<,'>, which
	-- is exactly the range these expect — no custom wrapper needed.
	{ "<leader>nk", ":Obsidian link<cr>", desc = "Link selection to an existing note", mode = "v" },
	{ "<leader>nK", ":Obsidian link_new<cr>", desc = "Link selection to a new note", mode = "v" },
	{ "<leader>nx", ":Obsidian extract_note<cr>", desc = "Extract selection into a new note", mode = "v" },
	-- Global ]d/[d/]D/[D are already Neovim's built-in diagnostic-nav
	-- defaults (confirmed via nvim_get_keymap) — namespaced under <leader>n
	-- instead so daily-note nav doesn't clobber them.
	{ "<leader>n]", "<cmd>Obsidian tomorrow<cr>", desc = "Tomorrow's daily note" },
	{ "<leader>n[", "<cmd>Obsidian yesterday<cr>", desc = "Yesterday's daily note" },
})
