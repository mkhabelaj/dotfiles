return {
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_restore_enabled = false,
			auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
		})

		require("which-key").add({
			-- ╭─────────────────────────────────────────────────────────╮
			-- │ Workspace & Session Management                          │
			-- ╰─────────────────────────────────────────────────────────╯
			{ "<leader>w", group = "Workspace" },
			{ "<leader>wQ", "<cmd>qa<CR>", desc = "Quit all windows" },
			{ "<leader>wr", "<cmd>SessionRestore<CR>", desc = "Restore session" },
			{ "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session" },
			{ "<leader>ww", "<cmd>w!<CR>", desc = "Save file" },
			{ "<leader>wW", "<cmd>noa w!<CR>", desc = "Save without autocmd" },
		})
	end,
}
