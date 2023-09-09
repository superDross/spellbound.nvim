-- Highlight
-- all the highlighting logic


local highlight = {}

-- highlight the word under the cursor, it assumes that the cursor is on the
-- starting character of the word
function highlight.under_cursor()
  local word = vim.fn.expand('<cword>')
  local pos = vim.fn.getpos('.')
  local line, col = pos[2], pos[3]

  local match_id = vim.fn.matchaddpos('SpellBoundFixHighlight', { { line, col, #word } })

  vim.fn.timer_start(vim.g.spellbound_settings.highlight.timer, function()
    vim.fn.matchdelete(match_id)
  end)
end

return highlight
