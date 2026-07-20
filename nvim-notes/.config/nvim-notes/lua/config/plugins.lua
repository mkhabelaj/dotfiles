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
	-- Completion engine. Pinned for reproducibility; lua fuzzy impl below
	-- means no prebuilt binary/cargo build is needed under vim.pack.
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.10.2" },
	-- noice floats the `:` cmdline (nui is its UI dep). Only the cmdline view is
	-- used; messages/popupmenu stay native to keep this writing config light.
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
})

require("nvim-treesitter").install({ "markdown", "markdown_inline", "yaml" })

require("mini.icons").setup()

-- Current obsidian workspace name (personal/work). Global `Obsidian` is set by
-- obsidian.setup below; read via a function so statusline/dashboard stay live
-- and update when the workspace is switched. Guarded for pre-setup/non-note.
local function ws_name()
	return (Obsidian and Obsidian.workspace and Obsidian.workspace.name) or ""
end

-- Statusline (mini.statusline ships with mini.nvim — no extra plugin) with a
-- workspace section so it's always clear which vault you're writing in.
local MS = require("mini.statusline")
MS.setup({
	use_icons = true,
	content = {
		active = function()
			local mode, mode_hl = MS.section_mode({ trunc_width = 120 })
			local filename = MS.section_filename({ trunc_width = 140 })
			local location = MS.section_location({ trunc_width = 75 })
			local ws = ws_name()
			return MS.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				"%<",
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=",
				{ hl = "MiniStatuslineFileinfo", strings = { ws ~= "" and (" " .. ws) or nil } },
				{ hl = mode_hl, strings = { location } },
			})
		end,
	},
})

-- Markdown snippets for note-taking. mini.snippets ships with mini.nvim (no
-- extra plugin); gen_loader.from_lang() loads snippets/<ft>.lua per buffer,
-- so snippets/markdown.lua only activates in markdown. blink.cmp (below) is
-- the sole completion UI and surfaces these via its mini_snippets preset, so
-- mini's own expand/jump mappings are disabled here to avoid a second flow.
local snippets = require("mini.snippets")
snippets.setup({
	snippets = { snippets.gen_loader.from_lang() },
	mappings = { expand = "", jump_next = "", jump_prev = "", stop = "" },
	-- Hide the empty-tabstop virtual markers (default '•'/'∎') — read as
	-- undeletable junk; blink drives jumping so they're not needed.
	expand = {
		insert = function(snippet, _)
			return snippets.default_insert(snippet, { empty_tabstop = "", empty_tabstop_final = "" })
		end,
	},
})

-- Single seamless completion menu: obsidian-ls (backlinks [[, #tags, [^footnotes])
-- + harper-ls (grammar) via the lsp source, our markdown snippets via the
-- mini_snippets preset, plus buffer/path. Lua fuzzy impl = no native binary.
require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },
		["<C-Space>"] = { "show", "fallback" },
		["<C-e>"] = { "hide" },
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
	},
	snippets = { preset = "mini_snippets" },
	sources = {
		default = { "lsp", "snippets", "path", "buffer", "notes" },
		-- Buffer words are the weakest signal here — rank them below LSP/
		-- snippets/path so they only surface after the meaningful sources.
		providers = {
			buffer = { score_offset = -50 },
			-- Contextual note completions (callout types after `> [!`, date
			-- expansions after `/today`...) — see lua/notes.lua.
			notes = { module = "notes", name = "Notes", score_offset = 10 },
		},
	},
	fuzzy = { implementation = "lua" },
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 200 },
		-- No preselect: an autotriggered popup must never let <CR> silently
		-- accept an obsidian item (e.g. create a new note) — see obsidian docs.
		list = { selection = { preselect = false } },
	},
})

-- Float the `:` cmdline only; leave messages/popupmenu/notify native so this
-- stays a thin UI tweak rather than a full noice takeover.
require("noice").setup({
	cmdline = { enabled = true, view = "cmdline_popup" },
	messages = { enabled = false },
	popupmenu = { enabled = false },
	lsp = { progress = { enabled = false } },
	notify = { enabled = false },
})

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
	-- obsidian remaps normal-mode <CR> to a smart action (follow link / toggle
	-- checkbox / fold). With create_new=true (default) that action inserts a
	-- checkbox on ANY non-checkbox line — including empty ones — so plain <CR>
	-- spawned "- [ ]". create_new=false keeps toggle-on-existing but makes <CR>
	-- a normal newline elsewhere.
	checkbox = {
		create_new = false,
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
			-- A function section is re-resolved on each render, so the workspace
			-- stays live. (`text` itself isn't function-resolved by snacks.)
			function()
				local ws = ws_name() ~= "" and ws_name() or "unknown"
				return {
					text = { { " Workspace: " .. ws, hl = "SnacksDashboardSpecial" } },
					align = "center",
					padding = 1,
				}
			end,
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
	-- Group labels mirror main nvim (nvim/.config/nvim/lua/plugins/whichkey.lua)
	-- so muscle memory carries over; notes-specific groups (Notes, Zen) added.
	{ "<leader>t", group = "Theme" },
	{ "<leader>tt", "<cmd>Themify<cr>", desc = "Toggle theme" },
	{ "<leader>z", group = "Zen" },
	{ "<leader>u", group = "UI/Toggle" },
	{ "<leader>f", group = "Find" },
	{ "<leader>v", group = "Window" },
	{ "<leader>w", group = "Workspace" },
	-- <leader>la/<leader>ldl are buffer-local, set via LspAttach in
	-- core/lsp.lua (only exist where an LSP client is attached) — just the
	-- group labels live here for which-key discoverability.
	{ "<leader>c", group = "Code" },
	{ "<leader>l", group = "LSP" },
	{ "<leader>ld", group = "Diagnostics" },

	-- General utilities (mirror main nvim).
	{ "<leader>\\", "<cmd>nohl<CR>", desc = "Clear highlights" },
	{ "<leader>ve", "<C-w>=", desc = "Equalize splits" },
	{ "<leader>vh", "<C-w>s", desc = "Split horizontally" },
	{ "<leader>vv", "<C-w>v", desc = "Split vertically" },
	{ "<leader>vx", "<cmd>close<CR>", desc = "Close split" },
	{ "<leader>ww", "<cmd>w!<CR>", desc = "Save file" },
	{ "<leader>wW", "<cmd>noa w!<CR>", desc = "Save without autocmd" },
	{ "<leader>wQ", "<cmd>qa<CR>", desc = "Quit all windows" },

	-- Muscle-memory find/grep on main's keys, routed to vault-aware obsidian
	-- actions (replacement, not a parallel picker set). Named commands still
	-- live under <leader>n* below.
	{ "<leader>/", "<cmd>Obsidian search<cr>", desc = "Grep notes" },
	{ "<leader><Space>", "<cmd>Obsidian quick_switch<cr>", desc = "Find note" },
	{ "<leader>ff", "<cmd>Obsidian quick_switch<cr>", desc = "Find note" },
	{
		"<leader>,",
		function()
			Snacks.picker.buffers()
		end,
		desc = "Buffers",
	},

	{ "<leader>s", group = "Search" },
	{
		"<leader>sb",
		function()
			Snacks.picker.lines()
		end,
		desc = "Search buffer lines",
	},
	{
		"<leader>st",
		function()
			local root = (Obsidian and Obsidian.workspace and tostring(Obsidian.workspace.path)) or vim.uv.cwd()
			Snacks.picker.grep({ search = "- \\[ \\]", live = false, dirs = { root } })
		end,
		desc = "Open todos (vault)",
	},

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
