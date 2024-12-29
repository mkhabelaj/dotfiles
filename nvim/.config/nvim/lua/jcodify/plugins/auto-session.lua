return {
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_restore_enabled = false,
			auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
		})

		require("which-key").add({
			{ "<leader>w", group = "Workspace" },
			{ "<leader>wr", "<cmd>SessionRestore<CR>", desc = "Restore session for cwd" },
			{ "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session for auto session root dir" },
		})
	end,
}
