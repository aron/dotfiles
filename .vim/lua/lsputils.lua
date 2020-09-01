local utils = { }

function utils.has_diagnostics_at_cursor()
  local bufnr = vim.api.nvim_get_current_buf()
  local diagnostics = vim.lsp.util.diagnostics_by_buf[bufnr]
  if not diagnostics then
    return false
  end

  for _, diagnostic in pairs(diagnostics) do
    local start = diagnostic.range["start"]
    local finish = diagnostic.range["end"]

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    row = row - 1

    local line = vim.api.nvim_buf_get_lines(0, row, row+1, true)[1]
    local character = vim.str_utfindex(line, col)

    if row >= start.line and row <= finish.line and character >= start.character and character <= finish.character then
      return true
    end
  end

  return false
end

return utils

