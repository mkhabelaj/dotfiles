-- Contextual blink.cmp source for note-taking: obsidian callout types after
-- `> [!`, and date expansions after `/today` / `/tomorrow` / ... Registered as
-- the single "notes" provider in plugins.lua. Static scaffolds live in
-- snippets/markdown.lua instead — this source only handles computed/contextual
-- items that snippets can't express.

local CompletionItemKind = vim.lsp.protocol.CompletionItemKind

-- Obsidian's built-in callout types (github.com/obsidianmd docs).
local CALLOUTS = {
	"note", "abstract", "summary", "info", "todo", "tip", "hint", "important",
	"success", "check", "done", "question", "help", "faq", "warning", "caution",
	"failure", "danger", "error", "bug", "example", "quote", "cite",
}

local function date_items(word_len)
	local day = 86400
	local function make(label, value)
		return { label = label, value = value }
	end
	local specs = {
		make("/today", os.date("%Y-%m-%d")),
		make("/tomorrow", os.date("%Y-%m-%d", os.time() + day)),
		make("/yesterday", os.date("%Y-%m-%d", os.time() - day)),
		make("/now", os.date("%Y-%m-%d %H:%M")),
	}
	return specs, word_len
end

local source = {}

function source.new()
	return setmetatable({}, { __index = source })
end

function source:enabled()
	return vim.bo.filetype == "markdown"
end

function source:get_trigger_characters()
	return { "!", "/" }
end

function source:get_completions(ctx, callback)
	local col = ctx.cursor[2]
	local row0 = ctx.cursor[1] - 1
	local before = ctx.line:sub(1, col)
	local items = {}

	-- Callout types: line is `> [!` (optionally with a partial word).
	if before:match(">%s*%[!%a*$") then
		for _, name in ipairs(CALLOUTS) do
			items[#items + 1] = {
				label = name,
				kind = CompletionItemKind.EnumMember,
				insertText = name .. "] ",
			}
		end
		return callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = items })
	end

	-- Date expansions: a `/word` token under the cursor.
	local token = before:match("/%a*$")
	if token then
		local start_col = col - #token
		local range = {
			start = { line = row0, character = start_col },
			["end"] = { line = row0, character = col },
		}
		local specs = date_items()
		for _, spec in ipairs(specs) do
			items[#items + 1] = {
				label = spec.label,
				filterText = spec.label,
				kind = CompletionItemKind.Value,
				detail = spec.value,
				textEdit = { newText = spec.value, range = range },
			}
		end
		return callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = items })
	end

	return callback({ is_incomplete_forward = false, is_incomplete_backward = false, items = {} })
end

return source
