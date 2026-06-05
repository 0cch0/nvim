vim.opt.tabstop = 5
vim.opt.shiftwidth = 5
vim.opt.number = true
vim.opt.signcolumn = "yes:1"
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 10
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.swapfile = false

vim.pack.add({ "https://github.com/kepano/flexoki-neovim" })
vim.cmd.colorscheme("flexoki")

-- [[ TREESITTER ]]
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })
local languages = { "c", "odin", "html", "javascript", "typescript", "astro" }
require("nvim-treesitter").install(languages)
vim.api.nvim_create_autocmd("FileType", {
	pattern = languages,
	callback = function()
		vim.treesitter.start()
	end,
})

-- [[ LSP ]]
vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })
vim.pack.add({ "https://github.com/mason-org/mason.nvim" })
require("mason").setup()
local servers = {
	clangd = {},
	ols = {},
	stylua = {},
}
for name, opts in pairs(servers) do
	vim.lsp.config(name, opts)
	vim.lsp.enable(name)
end

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Format on save",
	pattern = "*",
	callback = function()
		vim.lsp.buf.format({ builtin = true, async = false })
	end,
})

-- [[ TELESCOPE ]]
vim.pack.add({ "https://github.com/nvim-telescope/telescope.nvim" })
vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim" })
require("telescope").setup({
	pickers = {
		find_files = { theme = "dropdown" },
		live_grep = { theme = "dropdown" },
	},
})
local tb = require("telescope.builtin")
vim.keymap.set("n", "<space>sf", tb.find_files)
vim.keymap.set("n", "<space>sg", tb.live_grep)
vim.keymap.set("n", "<space><space>", tb.buffers)
vim.keymap.set("n", "<space>sc", function()
	tb.find_files({ cwd = vim.fn.stdpath("config") })
end)

-- [[ STATUSLINE ]]
vim.pack.add({ "https://github.com/nvim-mini/mini.statusline" })
local statusline = require("mini.statusline")
statusline.setup({ use_icons = true })
statusline.section_location = function()
	return "%2l:%-2v - %p%%"
end

-- [[ GIT ]]
vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })
require("gitsigns").setup({
	signs = {
		add = { text = "┃+" },
		change = { text = "┃~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Clear highlights on search when pressing <Esc> in normal mode.
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<C-i>", function()
	vim.diagnostic.open_float()
end)
