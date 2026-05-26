return {
	"rmagatti/auto-session",
	lazy = false,
	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	keys = {
		-- ╭─────────────────────────────────────────────────────────╮
		-- │ Workspace & Session Management                          │
		-- ╰─────────────────────────────────────────────────────────╯
		{ "<leader>wQ", "<cmd>qa<CR>", desc = "Quit all windows" },
		{ "<leader>wr", "<cmd>AutoSession restore<CR>", desc = "Restore session" },
		{ "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session" },
		{ "<leader>wd", "<cmd>AutoSession delete<CR>", desc = " deletes a session based on the `cwd` from `root_dir" },
		{ "<leader>we", "<cmd>AutoSession enable<CR>", desc = "Enable session" },
		{ "<leader>wx", "<cmd>AutoSession disable<CR>", desc = "Disable session" },
		{ "<leader>ww", "<cmd>w!<CR>", desc = "Save file" },
		{ "<leader>wW", "<cmd>noa w!<CR>", desc = "Save without autocmd" },
	},
	opts = {
		suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		-- log_level = 'debug',
	},
}
