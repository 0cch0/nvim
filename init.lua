vim.pack.add({
	"https://github.com/kepano/flexoki-neovim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-mini/mini.nvim",
})

vim.cmd.colorscheme("flexoki")

vim.opt.tabstop = 5
vim.opt.shiftwidth = 5
vim.opt.number = true
vim.opt.signcolumn = "yes:1"
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 10
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- [[ TREESITTER ]]
local languages = { "odin", "c", "html", "javascript", "typescript", "astro" }
require("nvim-treesitter").install(languages)
vim.api.nvim_create_autocmd("FileType", {
	pattern = languages,
	callback = function()
		vim.treesitter.start()
	end,
})

-- [[ LSP ]]
require("mason").setup({})
vim.lsp.enable("ols")
vim.lsp.config("lua_ls", {
	settings = {
		Lua = { format = { enable = false } },
	},
})
vim.lsp.enable("lua_ls")
vim.lsp.enable("stylua")

-- [[ CONFORM - FORMATTING ]]
require("conform").setup({
	formatters_by_ft = {
		odin = { "odinfmt", "stylua" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- [[ TELESCOPE ]]
require("telescope").setup({
	pickers = {
		find_files = { theme = "dropdown" },
		live_grep = { theme = "dropdown" },
	},
})
local b = require("telescope.builtin")
vim.keymap.set("n", "<space>sf", b.find_files)
vim.keymap.set("n", "<space>sg", b.live_grep)
vim.keymap.set("n", "<space><space>", b.buffers)
vim.keymap.set("n", "<space>sc", function()
	b.find_files({ cwd = vim.fn.stdpath("config") })
end)

-- [[ Mini ]]
local statusline = require("mini.statusline")
statusline.setup({ use_icons = true })
statusline.section_location = function()
	return "%2l:%-2v"
end

-- Clear highlights on search when pressing <Esc> in normal mode.
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
