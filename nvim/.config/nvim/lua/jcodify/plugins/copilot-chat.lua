return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "main",
	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim" },
	},
	opts = {
		debug = false,
		show_help = "yes",
		prompts = {
			Explain = "Explain how this code works.",
			Review = "Review the following code and provide concise suggestions.",
			Tests = "Briefly explain how the selected code works, then generate unit tests.",
			Refactor = "Refactor this code to improve clarity and readability.",
		},
	},
	keys = {
		-- Toggle chat
		{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
		-- Quick actions
		{ "<leader>ce", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "Explain code" },
		{ "<leader>ct", "<cmd>CopilotChatTests<cr>", mode = { "n", "v" }, desc = "Generate tests" },
		{ "<leader>cr", "<cmd>CopilotChatReview<cr>", mode = { "n", "v" }, desc = "Review code" },
		{ "<leader>cR", "<cmd>CopilotChatRefactor<cr>", mode = { "n", "v" }, desc = "Refactor code" },
		{ "<leader>cf", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "Fix code" },
		{ "<leader>co", "<cmd>CopilotChatOptimize<cr>", mode = { "n", "v" }, desc = "Optimize code" },
		{ "<leader>cd", "<cmd>CopilotChatDocs<cr>", mode = { "n", "v" }, desc = "Generate docs" },
		-- Custom prompts
		{
			"<leader>cq",
			function()
				local input = vim.fn.input("Ask Copilot: ")
				if input ~= "" then
					vim.cmd("CopilotChat " .. input)
				end
			end,
			desc = "Ask Copilot custom question",
		},
	},
}
