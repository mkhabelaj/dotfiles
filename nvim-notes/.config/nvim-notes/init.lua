-- nvim-notes: standalone writing / Obsidian-vault-aware note-taking config.
--
-- localleader = ; : main leaves it at vim's default `\`; nvim-octo uses `,`
-- for its review keymaps. Picking a third, distinct key keeps muscle memory
-- from cross-wiring between the three configs, even though there's no
-- runtime collision (only one NVIM_APPNAME is ever active at a time).
vim.g.mapleader = " "
vim.g.maplocalleader = ";"

require("config.core")
require("config.plugins")
