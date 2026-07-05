vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt -- for conciseness

-- line numbers: absolute only. Relative numbers are for jump-count math in
-- code editing; less useful in prose, so left off.
opt.number = true
opt.relativenumber = false

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- writing: soft-wrap at window edge, break on word boundaries, indent
-- wrapped lines to match the paragraph's start (not column 0).
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.showbreak = "↳ " -- visual marker for a wrapped continuation line

-- "typewriter" scrolling: keep the cursor line vertically centered so your
-- eyes stay put while text scrolls around it. Dial back to e.g. 8 if this
-- feels disorienting when jumping between distant lines.
opt.scrolloff = 999

-- markdown-only concealing (wiki links, emphasis markers, etc. via
-- render-markdown.nvim / treesitter) — scoped by filetype, not global, so
-- other filetypes (help, json, ...) aren't affected.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.conceallevel = 2
		vim.opt_local.concealcursor = "nc"
	end,
})

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
-- On WSL with win32yank installed, set it explicitly to skip the slow 10s auto-detection probe.
-- Without win32yank, fall back to Neovim's auto-detection (clip.exe / powershell).
if vim.fn.has("wsl") == 1 and vim.fn.executable("win32yank.exe") == 1 then
	vim.g.clipboard = {
		name = "win32yank",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --lf",
			["*"] = "win32yank.exe -o --lf",
		},
		cache_enabled = 0,
	}
end
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- faster CursorHold (reduces delay for snacks words/LSP highlights after cursor move)
opt.updatetime = 250
-- fast terminal key code timeout (reduces <Esc> sequence ambiguity)
opt.ttimeoutlen = 50
-- which-key popup delay
opt.timeout = true
opt.timeoutlen = 500

-- set spell check to English Canada
opt.spelllang = "en_ca"
-- enable spell check
opt.spell = true

-- Set SessionOptions to save session options
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
