-- mini.snippets markdown set for nvim-notes. Loaded per-filetype by
-- gen_loader.from_lang() in plugins.lua. Bodies use LSP snippet syntax
-- ($1, ${1:placeholder}, $0). Expand with <C-j>, jump with <C-l>/<C-h>.
return {
	{ prefix = "table", body = "| ${1:h1} | ${2:h2} |\n| --- | --- |\n| $3 | $4 |$0", desc = "Table (2 cols)" },
	{ prefix = "code", body = "```${1:lang}\n$2\n```$0", desc = "Fenced code block" },
	{ prefix = "list", body = "- $1", desc = "Bullet list item" },
	{ prefix = "ol", body = "1. $1", desc = "Numbered list item" },
	{ prefix = "task", body = "- [ ] $1", desc = "Task checkbox" },
	{ prefix = "link", body = "[${1:text}]($2)$0", desc = "Link" },
	{ prefix = "img", body = "![${1:alt}]($2)$0", desc = "Image" },
	{ prefix = "quote", body = "> $1", desc = "Blockquote" },
	{ prefix = "h1", body = "# $1", desc = "Heading 1" },
	{ prefix = "h2", body = "## $1", desc = "Heading 2" },
	{ prefix = "h3", body = "### $1", desc = "Heading 3" },
}
