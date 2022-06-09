local M = {}

function M.save()
	if vim.bo.buftype ~= "terminal" then
		return
	end
	vim.w.rubix_term_mode = vim.fn.mode()
end

function M.wrap(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = true
	opts.expr = true

	vim.keymap.set(mode, lhs, function()
		M.save()
		return rhs
	end, opts)
end

return M
