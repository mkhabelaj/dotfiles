function ToggleZenMode()
	local filetype = vim.bo.filetype
	local width = 80
	local zen_mode = require("zen-mode")

	if filetype == "markdown" or filetype == "text" or filetype == "gitcommit" then
		width = 80
		-- Open Zen Mode with dynamic width
		zen_mode.open({
			window = {
				width = width,
			},
		})
		return
	end

	-- use default width settings
	zen_mode.toggle()
end
