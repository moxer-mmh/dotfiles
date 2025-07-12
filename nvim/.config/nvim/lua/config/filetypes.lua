vim.filetype.add({
	pattern = {
		[".*%.env.*"] = "dotenv",
	},
	extension = {
		md = "markdown",
		mdx = "markdown",
		markdown = "markdown",
	},
})
