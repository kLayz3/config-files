-- bootstrap lazy.nvim, LazyVim and your plugins
vim.filetype.add({
	extension = {
		txx = "cpp",
	},
})
require("config.lazy")
