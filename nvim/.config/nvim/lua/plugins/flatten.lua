return {
	"willothy/flatten.nvim",
	lazy = false,
	priority = 1001, -- must load before other plugins to catch nested instances
	opts = function()
		-- The commit buffer must not open inside the lazygit float: hide the
		-- float while editing, bring it back when the nested session ends.
		local hid_lazygit = false
		return {
			window = { open = "alternate" },
			hooks = {
				pre_open = function()
					if vim.bo.filetype == "snacks_terminal" then
						hid_lazygit = true
						vim.api.nvim_win_close(vim.api.nvim_get_current_win(), false)
					end
				end,
				block_end = function()
					vim.schedule(function()
						if hid_lazygit then
							hid_lazygit = false
							Snacks.lazygit()
						end
					end)
				end,
			},
		}
	end,
}
