-- Ctrl-h/j/k/l pane navigation that works under BOTH multiplexers:
--   * inside tmux  -> defer to vim-tmux-navigator (uses $TMUX).
--   * inside herdr -> move the nvim split; at the edge hand off to
--                     `herdr pane focus`. The herdr side (config.toml
--                     [[keys.command]] + herdr-vim-nav.sh) forwards the chord
--                     into nvim when nvim is the focused pane.
local function nav(dir, wincmd, tmux_cmd)
	return function()
		if vim.env.TMUX then
			vim.cmd(tmux_cmd)
		elseif vim.env.HERDR_PANE_ID then
			local cur = vim.api.nvim_get_current_win()
			vim.cmd("wincmd " .. wincmd)
			if cur == vim.api.nvim_get_current_win() then
				-- at the split edge → hand off to the neighbouring herdr pane.
				-- target this pane explicitly; --current resolves server-side.
				vim.system({ "herdr", "pane", "focus", "--direction", dir, "--pane", vim.env.HERDR_PANE_ID })
			end
		else
			vim.cmd("wincmd " .. wincmd)
		end
	end
end

return {
	"christoomey/vim-tmux-navigator",
	-- Stop the plugin from binding its own <C-h/j/k/l>, which would clobber the
	-- `nav` mappings below the moment it lazy-loads.
	init = function()
		vim.g.tmux_navigator_no_mappings = 1
	end,
	cmd = {
		"TmuxNavigateLeft",
		"TmuxNavigateDown",
		"TmuxNavigateUp",
		"TmuxNavigateRight",
		"TmuxNavigatePrevious",
		"TmuxNavigatorProcessList",
	},
	keys = {
		{ "<c-h>", nav("left", "h", "TmuxNavigateLeft"), desc = "Nav left (nvim/tmux/herdr)" },
		{ "<c-j>", nav("down", "j", "TmuxNavigateDown"), desc = "Nav down (nvim/tmux/herdr)" },
		{ "<c-k>", nav("up", "k", "TmuxNavigateUp"), desc = "Nav up (nvim/tmux/herdr)" },
		{ "<c-l>", nav("right", "l", "TmuxNavigateRight"), desc = "Nav right (nvim/tmux/herdr)" },
		{ "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
	},
}
