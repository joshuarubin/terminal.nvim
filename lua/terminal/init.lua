local M = {}

local augroup = vim.api.nvim_create_augroup("terminal.nvim", {})

local function terminal_setup(opts)
	local bufnr = opts.bufnr or 0

	if vim.api.nvim_buf_get_option(bufnr, "buftype") ~= "terminal" then
		return
	end

	if vim.g.terminal_autoinsert ~= 0 then
		vim.cmd("startinsert")
	end

	vim.api.nvim_create_autocmd("BufEnter", {
		desc = "restore terminal mode on enter",
		buffer = bufnr,
		callback = function()
			if vim.g.terminal_autoinsert ~= 0 and vim.w.rubix_term_mode == "t" then
				vim.cmd("startinsert")
			end
		end,
		group = augroup,
	})

	vim.api.nvim_create_autocmd("BufLeave", {
		desc = "restore terminal mode on enter",
		buffer = bufnr,
		callback = function()
			vim.w.rubix_term_mode = vim.fn.mode()
		end,
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
