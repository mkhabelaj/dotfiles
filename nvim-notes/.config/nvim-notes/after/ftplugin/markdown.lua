-- Continue markdown lists when writing. Neovim's stock markdown ftplugin sets
-- the bullet `comments` with the `f` flag (leader on first line only), which
-- suppresses auto-continuation. Override with plain `b:` leaders so the `r`
-- (insert <Enter>) and `o` (normal o/O) format options repeat them.
--
-- Checkbox leaders are listed before the bare `-`/`*` so `- [ ]` matches first
-- and a task line continues as another unchecked task. Numbered lists aren't
-- handled here (comments only do fixed leaders) — that'd need a plugin.
vim.opt_local.comments = "b:- [ ],b:- [x],b:* [ ],b:* [x],b:-,b:*,b:+,n:>"
vim.opt_local.formatoptions:append("r")
vim.opt_local.formatoptions:append("o")
