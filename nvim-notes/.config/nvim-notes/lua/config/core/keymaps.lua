local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jj to exit insert mode
keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jj" })

-- On WSL, <C-i> and <Tab> are byte-identical (0x09). Without this explicit
-- mapping nvim waits timeoutlen before dispatching, making jumplist feel slow.
keymap.set("n", "<Tab>", "<C-i>", { desc = "Jump forward in jumplist" })

-- Quit (save is <leader>ww under the Workspace group in plugins.lua wk.add,
-- matching main nvim; <leader>w stays a group prefix).
keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })

-- Window navigation. Plain wincmd — this config stays lean with no
-- vim-tmux-navigator/herdr dependency.
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Nav left" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Nav down" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Nav up" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Nav right" })

---------------------------
-- Writing-specific toggles
---------------------------

keymap.set("n", "<leader>us", function()
	vim.opt_local.spell = not vim.opt_local.spell:get()
	vim.notify("spell: " .. tostring(vim.opt_local.spell:get()))
end, { desc = "Toggle spell check" })

keymap.set("n", "<leader>uw", function()
	vim.opt_local.wrap = not vim.opt_local.wrap:get()
	vim.notify("wrap: " .. tostring(vim.opt_local.wrap:get()))
end, { desc = "Toggle line wrap" })

keymap.set("n", "<leader>uc", function()
	local wc = vim.fn.wordcount()
	local msg = wc.visual_words and string.format("%d words selected (%d chars)", wc.visual_words, wc.visual_chars)
		or string.format("%d words, %d chars", wc.words, wc.chars)
	vim.notify(msg, vim.log.levels.INFO, { title = "Word count" })
end, { desc = "Word count" })
