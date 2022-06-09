local M = {}

M.save = require("terminal.save")

local augroup = vim.api.nvim_create_augroup("terminal.nvim", {})

local function terminal_restore()
	if vim.bo.buftype ~= "terminal" then
		return
	end
	local mode = vim.w.rubix_term_mode
	if mode == nil then
		return
	end

	if mode == "t" then
		vim.cmd("startinsert")
	end
end

local function terminal_setup()
	vim.cmd("startinsert")
	vim.api.nvim_create_autocmd("BufEnter", {
		desc = "restore terminal mode on enter",
		buffer = 0,
		callback = terminal_restore,
		group = augroup,
	})
end

M.setup = function()
	vim.api.nvim_create_autocmd("TermOpen", {
		desc = "start new terminals in insert mode",
		pattern = "*",
		callback = terminal_setup,
		group = augroup,
	})

	vim.api.nvim_create_autocmd("TermOpen", {
		desc = "some good default settings for terminals",
		pattern = "*",
		command = "setlocal nonumber nospell signcolumn=no sidescrolloff=0 scrolloff=0",
		group = augroup,
	})
end

return M
