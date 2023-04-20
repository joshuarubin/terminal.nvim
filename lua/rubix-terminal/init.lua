local M = {}

local settings = {
	autoinsert = true,
	nohlsearch = true,
}

local augroup = vim.api.nvim_create_augroup("terminal.nvim", {})

local function terminal_setup(opts)
	local bufnr = opts.bufnr or 0

	if bufnr == 0 then
		bufnr = vim.api.nvim_get_current_buf()
	end

	if vim.bo[bufnr].buftype ~= "terminal" then
		return
	end

	-- some good default settings for terminals
	for _, winnr in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(winnr)
		if buf == bufnr then
			vim.wo[winnr].number = false
			vim.wo[winnr].scrolloff = 0
			vim.wo[winnr].sidescrolloff = 0
			vim.wo[winnr].signcolumn = "no"
			vim.wo[winnr].spell = false
		end
	end

	if settings.autoinsert then
		vim.cmd("startinsert")
	end

	if settings.nohlsearch and vim.o.hlsearch == true then
		vim.o.hlsearch = false
	end

	vim.api.nvim_create_autocmd("BufEnter", {
		desc = "restore terminal mode on enter",
		buffer = bufnr,
		callback = function()
			if settings.autoinsert and vim.w.rubix_term_mode == "t" then
				vim.cmd("startinsert")
			end

			if settings.nohlsearch and vim.o.hlsearch == true then
				vim.o.hlsearch = false
			end
		end,
		group = augroup,
	})

	vim.api.nvim_create_autocmd("BufLeave", {
		desc = "restore terminal mode on enter",
		buffer = bufnr,
		callback = function()
			vim.w.rubix_term_mode = vim.fn.mode()
			if settings.nohlsearch and vim.o.hlsearch == false then
				vim.o.hlsearch = true
			end
		end,
		group = augroup,
	})
end

M.setup = function(opts)
	opts = opts or {}
	opts.autoinsert = opts.autoinsert or true
	opts.nohlsearch = opts.nohlsearch or true

	settings.autoinsert = opts.autoinsert == true
	settings.nohlsearch = opts.nohlsearch == true

	vim.api.nvim_create_autocmd("TermOpen", {
		pattern = "*",
		callback = terminal_setup,
		group = augroup,
	})
end

return M
