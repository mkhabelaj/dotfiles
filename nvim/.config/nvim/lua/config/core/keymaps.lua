-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jj" })

-- On WSL, <C-i> and <Tab> are byte-identical (0x09). Without this explicit
-- mapping nvim waits timeoutlen before dispatching, making jumplist feel slow.
keymap.set("n", "<Tab>", "<C-i>", { desc = "Jump forward in jumplist" })
